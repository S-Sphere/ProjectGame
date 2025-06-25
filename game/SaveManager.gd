extends Node

const SAVE_FILE := "savegame.json"
var save_path: String = OS.get_executable_path().get_base_dir().path_join(SAVE_FILE)

var data: Dictionary = {
	"coins"			: 0,
	"upgrades"		: {},
	"player_stats"	: {},
	"settings"		: {}
}

func _ready() -> void:
	load_json()

func save_json() -> void:
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		file.close()

func load_json() -> void:
	var file = FileAccess.open("save_path", FileAccess.READ)
	if file:
		var text = file.get_as_text()
		file.close()
		var parsed = JSON.parse_string(text)
		if typeof(parsed) == TYPE_DICTIONARY:
			for k in parsed.keys():
				data[k] = parsed[k]
