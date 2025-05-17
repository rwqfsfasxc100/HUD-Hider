extends "res://Settings.gd"

# You may want to change many of the variable names to provide a unique identifier
# Make sure anything read by the ModMain is consistent with this file or they will not work
# These are default config values
# Any value not set in the config file will generate the missing values exactly as these are
var HUD_Hider = {
	"input":{ # Defaults for anything that uses keybinds
		"toggle_hud":[ "F6" ],
	}, 
}

# The config file name. Make sure you set something unique
# Config is set to the cfg folder to make it easy to find
var HUD_Hider_ConfigPath = "user://cfg/HUD_Hider.cfg"
var HUD_Hider_CfgFile = ConfigFile.new()

func _ready():
	var dir = Directory.new()
	dir.make_dir("user://cfg")
	load_HUD_Hider_FromFile()
	save_HUD_Hider_ToFile()


func save_HUD_Hider_ToFile():
	for section in HUD_Hider:
		for key in HUD_Hider[section]:
			HUD_Hider_CfgFile.set_value(section, key, HUD_Hider[section][key])
	HUD_Hider_CfgFile.save(HUD_Hider_ConfigPath)


func load_HUD_Hider_FromFile():
	var error = HUD_Hider_CfgFile.load(HUD_Hider_ConfigPath)
	if error != OK:
		Debug.l("Example Mod: Error loading settings %s" % error)
		return 
	for section in HUD_Hider:
		for key in HUD_Hider[section]:
			HUD_Hider[section][key] = HUD_Hider_CfgFile.get_value(section, key, HUD_Hider[section][key])
	loadKeymapsFromConfig()

# Keybind setting handlers
func loadKeymapsFromConfig():
	for action_name in HUD_Hider.input:
		var addAction = true
		for m in InputMap.get_actions():
			if m == action_name:
				addAction = false
		if addAction:
			InputMap.add_action(action_name)
		for key in HUD_Hider.input[action_name]:
			var event = InputEventKey.new()
			event.scancode = OS.find_scancode_from_string(key)
			InputMap.action_add_event(action_name, event)
	emit_signal("controlSchemeChaged")
