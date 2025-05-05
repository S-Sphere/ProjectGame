#XP bar
extends TextureProgressBar
@onready var level_label = $MarginContainer/LevelLabel



func _ready():
	GameManager.connect("xp_changed", Callable(self, "_on_xp_changed"))
	max_value = GameManager.xp_to_next_level
	value = GameManager.xp
	level_label.text = "LV " + str(GameManager.level)
	
func _on_xp_changed(current_xp, xp_cap):
	max_value = xp_cap
	value = current_xp
	level_label.text = "LV " + str(GameManager.level)
