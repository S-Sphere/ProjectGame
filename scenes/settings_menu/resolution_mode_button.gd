extends Control

@onready var option_button = $HBoxContainer/OptionButton as OptionButton

const RESOLUTION_DICT : Dictionary = {
	"1152 x 648" : Vector2i(1152, 648),
	"1280 x 720" : Vector2i(1280, 720),
	"1920 x 1080" : Vector2i(1920, 1080)
}
var DISPLAY_RESOLUTION_KEYS : Array = RESOLUTION_DICT.keys()

func _ready():
	add_resolution_items()
	current_resolution()
	option_button.item_selected.connect(on_resolution_selected)


func add_resolution_items() -> void:
	for resolution_size in RESOLUTION_DICT:
		option_button.add_item(resolution_size)

func current_resolution() -> void:
	pass

func centre_window() -> void:
	var centre_screen = DisplayServer.screen_get_position() + DisplayServer.screen_get_size()/2
	var window_size = get_window().get_size_with_decorations()
	get_window().set_position(centre_screen - window_size/2)

func on_resolution_selected(index : int) -> void:
	match index:
		0: # 1152 x 648
			DisplayServer.window_set_size(RESOLUTION_DICT.values()[index])
			centre_window()
		1: # 1280 x 720
			DisplayServer.window_set_size(RESOLUTION_DICT.values()[index])
			centre_window()
		2: # 1920 x 1080
			DisplayServer.window_set_size(RESOLUTION_DICT.values()[index])
			centre_window()
