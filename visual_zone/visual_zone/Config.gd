extends Node

var McmHelpers = preload("res://ModConfigurationMenu/Scripts/Doink Oink/MCM_Helpers.tres")

const MOD_ID    = "visual_zone"
const FILE_PATH = "user://MCM/visual_zone"

func _ready():
	var _config = ConfigFile.new()

	_config.set_value("Dropdown", "lut_preset", {
		"name"    = "LUT Preset",
		"tooltip" = "Color grading inspired by STALKER and Tarkov",
		"default" = "Default",
		"value"   = "Default",
		"options" = {
			"Default": "Default",
			"Zone":    "Zone",
			"Pripyat": "Pripyat",
			"Anomaly": "Anomaly",
			"Tarkov":  "Tarkov",
			"Woods":   "Woods",
			"Reserve": "Reserve"
		}
	})

	_config.set_value("Float", "lut_intensity", {
		"name"     = "LUT Intensity",
		"tooltip"  = "Blend between original image and LUT",
		"default"  = 0.85,
		"value"    = 0.85,
		"minRange" = 0.0,
		"maxRange" = 1.0
	})

	_config.set_value("Float", "exposure", {
		"name"     = "Exposure",
		"tooltip"  = "General brightness of the image",
		"default"  = 0.8,
		"value"    = 0.8,
		"minRange" = 0.0,
		"maxRange" = 3.0
	})

	_config.set_value("Float", "contrast", {
		"name"     = "Contrast",
		"tooltip"  = "Difference between bright and dark areas",
		"default"  = 1.0,
		"value"    = 1.0,
		"minRange" = 0.5,
		"maxRange" = 2.0
	})

	_config.set_value("Float", "saturation", {
		"name"     = "Saturation",
		"tooltip"  = "Intensity of the color",
		"default"  = 1.25,
		"value"    = 1.25,
		"minRange" = 0.0,
		"maxRange" = 2.0
	})

	if !FileAccess.file_exists(FILE_PATH + "/config.ini"):
		DirAccess.open("user://").make_dir(FILE_PATH)
		_config.save(FILE_PATH + "/config.ini")
	else:
		McmHelpers.CheckConfigurationHasUpdated(MOD_ID, _config, FILE_PATH + "/config.ini")
		_config.load(FILE_PATH + "/config.ini")

	McmHelpers.RegisterConfiguration(
		MOD_ID,
		"Visual Zone",
		FILE_PATH,
		"kakka",
		{"config.ini" = _on_config_updated}
	)

func _on_config_updated(config: ConfigFile):
	var main = get_node_or_null("/root/VisualZone")
	if main:
		main.apply_from_config(config)

func get_setting(section: String, key: String, default_val):
	var _config = ConfigFile.new()
	if _config.load(FILE_PATH + "/config.ini") != OK:
		return default_val
	var data = _config.get_value(section, key, null)
	if data is Dictionary and data.has("value"):
		return data["value"]
	return default_val