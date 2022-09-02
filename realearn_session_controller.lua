--[[

	Realearn Bot 0.1

	A fill in for controlling Realearn externally.
	
	In time a mature and robust API will be made available by the Realearn author, Helgoboss
	
	In the mean time, those of us who wish to get going with their Realearn control 
	projects can potentially start hacking around now, with the view to adapt to the official API later

	If you like this or find it useful, please consider donating to Helgoboss to support 
	his efforts
	
	Why would anyone want this?
	
	Since Helgoboss himself alludes to the sheer fun of hacking when revealing in the manual the 
	clue around set-state.
	
	Also he has confirmed elsewhere that there are plans for exposing various elements of the session
	to outside (Reascript) control.
	
	I have a few plans around auto generating standardised mappings for a HUGE VSTi library among other things. 
	Any reasons for doing this will probably be superceded by new functionality in the main Realearn later.
	
	But for now...
	
	REQUIRED:
	
	1.	Realearn.  Install from Reapack:
	
		https://github.com/helgoboss/realearn#installation
		
	2.	Realearn Bot
		
	LIMITATIONS:
	
	1.  There is no current way to obtain the state / session of a Realearn instance
		via scripting.  However we are able to update the sesssion in a Realearn instance with control
		over both compartments (main/controller) as well as the core session settings 
		(MIDI routing essentially).
		
		Therefore the way we have available to us is to load the main and controller presets 
		from the file system, and then combine them with some more data fields to get the
		session we want.
		
		This solution enables us to load presets into Realearn instances the normal way, then 
		programatically manipulate their properties (config/mappings) freely from our scripts 
		
	2.	This solution utilises a non-supported debugging feature which allows a full session to be 
		injected into Realern for diagnostic purposes.  As such the modality for this has not been 
		designed to be used this way, so there may be edge cases where unexpected results ensue.
		
		Please bear this in mind if things don't work out.  A lot of work goes into supporting features 
		being used as designed. Feel free to request help from me (jamesd256 on Reaper forums), but 
		please don't expect support from the author of Realearn.  At least wait until Helgoboss finishes
		his current musical sojourn and gives us Playtime 2.  Then you can start nagging abut the official API.	
		
		DONATE to Helgoboss :)
		
	3.  In relation to the point above, the data format design includeing field naming and structure
		has not been created with public use in mind.  Once the full API is available, no doubt it 
		will be made more polished and fit for purpose
]]--

-- set the Reaper script root path
script_path = debug.getinfo(1,"S").source:match[[^@?(.+[\/])]]

-- Required modules
dofile(script_path .. "lib.lua")
JSON = dofile(script_path .. "JSON.lua")
JSON.strictTypes = true

--[[
	 1:

	 To build a valid and complete Realearn session, we need to collate mapping 
	 data from both controller and main presets, and set a few things like:
	 
	   - Midi device ids (control and feedback)
	   - Which presets are selected
	   - Some session wide options (let through stuff
	 
	 To understand better how to set all this, hit export from an instance of Realarn,
	 and choose 'Export session as JSON' for more insight
	   
	   ----- Edit the fields below to setup the session you'd like to tweak --------
]]--

local session_context = {
	["main_preset_id"] 			= "reabot",  		 -- These must match the file names of the presets, without the extesion (.json)
	["controller_preset_id"] 	= "test-controller", -- Do not enter the name of the preset as it appears in the drop down list
	["control_device_id"]		= "12",				 -- Numeric device ids can be found in the contol/feedback dropdowns from
    ["feedback_device_id"]		= "12" 				 -- within Realearn, or the ID column in Reaper 	Preferences -> Midi Devices
} 

-- creates the session data ready for Realern
local session_data = build_session_data(session_context)



--[[

	2: 
	
	Alter/manipulate any fields in the data, or add/remove/switch mappings here:
	
	e.g.
	
	session_data["mappings"][1]["name"] = "new name"
	session_data["controllerMappings"][1]["name"] = "new csdfs name"
	
	Of course you are free to bypass step 1 and build your own session data from scratch

]]--


--

-- 3:
-- 
-- Finally we can now re-apply the manipulated session to our chosen Reelean
-- instance

-- tries the track selection approaches in order shown. Set to nil to bypass
local instance_context = {
	["useSelectedTrack"] 		= false, 
	["trackPosition"]			= nil, -- zero is the first one in the TCP
	["trackName"]				= "sdfsd",
	["instanceFXID"]			= 0  -- zero is the first one in the list
}

--send_session_to_relearn_instance(session_data,instance_context)



