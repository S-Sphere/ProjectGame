extends Node

var data: Dictionary = {
	"coins"			: 0,
	"upgrades"		: {},
	"player_stats"	: {},
	"settings"		: {}
}

func _ready() -> void:
	load_json()

func save_json() -> void:
	var file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		file.close()

func load_json() -> void:
	var file = FileAccess.open("user://savegame.json", FileAccess.READ)
	if file:
		var text = file.get_as_text()
		file.close()
		var parsed = JSON.parse_string(text)
		if typeof(parsed) == TYPE_DICTIONARY:
			for k in parsed.keys():
				data[k] = parsed[k]
