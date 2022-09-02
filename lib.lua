REALEARN_PRESET_PATH = "R:/Reaper/Data/helgoboss/realearn/presets/"
REALEARN_MAIN_PRESET_PATH = REALEARN_PRESET_PATH .. "main/"
REALEARN_CONTROLLER_PRESET_PATH = REALEARN_PRESET_PATH .. "controller/"

function load_realearn_preset(preset_type, name)
	if preset_type == 'controller' then
		preset_path = REALEARN_CONTROLLER_PRESET_PATH		
	else
		preset_path = REALEARN_MAIN_PRESET_PATH
    end
    reaper.ShowConsoleMsg(preset_path .. "\n")
	local file_path = preset_path .. name .. ".json"
	
	reaper.ShowConsoleMsg(file_path .. "\n")
	local file = io.open(file_path, "r")
	
	local preset_text = file:read("*a") 
	file:close() 
	local preset_data = JSON:decode(preset_text) 
	
	return preset_data 
end

function build_session_data(session_context)

	local main_preset_data = load_realearn_preset("main", session_context["main_preset_id"])
	local controller_preset_data = load_realearn_preset("controller", session_context["controller_preset_id"])

	-- Just re-use the main data as the session container
	main_preset_data["activeMainPresetId"] = session_context["main_preset_id"]
	main_preset_data["activeControllerId"] = session_context["controller_preset_id"]
	main_preset_data["controlDeviceId"] = session_context["control_device_id"]
	main_preset_data["feedbackDeviceId"] = session_context["feedback_device_id"]	
	main_preset_data["controllerMappings"] = controller_preset_data["mappings"]
	
	--reaper.ShowConsoleMsg(dump(main_preset_data))
	
	return main_preset_data
	
end

function send_session_to_relearn_instance(session_data, instance_context)

	local session_json = JSON:encode_pretty(session_data)	
	local track = resolve_track(instance_context)
	reaper.TrackFX_SetNamedConfigParm(track,instance_context["instanceFXID"],"set-state",session_json)
	
end

function resolve_track(instance_context)
	if instance_context["useSelectedTrack"] then
		return reaper.GetSelectedTrack(0 , 0)
	elseif instance_context["trackPosition"] then
		return reaper.GetTrack(0, instance_context["trackPosition"]);
	elseif instance_context["trackName"] then 
		return find_track_by_name(instance_context["trackName"])
	end
end

function find_track_by_name(track_name)
	for trackIdx = 0, reaper.CountTracks(0) - 1 do
        track = reaper.GetTrack(0, trackIdx)
        local name, flags = reaper.GetTrackState(track)
        if name == track_name then
        	return track
        end
    end
    return nil
end

-- Utility method for sending data to the console for inspection
function dump(o)
   if type(o) == 'table' then
      local s = '{ \n'
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '\t['..k..'] = ' .. dump(v) .. ',\n'
      end
      return s .. '} '
   else
      return tostring(o)
   end
end