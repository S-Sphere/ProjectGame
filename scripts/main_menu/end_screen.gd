extends CanvasLayer

@onready var coins_label = $VBoxContainer/CoinsLabel
@onready var level_label = $VBoxContainer/LevelLabel
@onready var kills_label = $VBoxContainer/KillsLabel
@onready var time_label = $VBoxContainer/TimeLabel
@onready var upgrades_label = $VBoxContainer/UpgradesLabel
@onready var retry_button = $VBoxContainer/Buttons/RetryButton
@onready var menu_button = $VBoxContainer/Buttons/MenuButton

func _ready():
	retry_button.pressed.connect(_on_retry_pressed)
	menu_button.pressed.connect(_on_menu_pressed)


func show_stats(data: Dictionary) -> void:
	coins_label.text = "Coins: %d" % data.get("coins", 0)
	level_label.text = "Level Reached: %d" % data.get("level", 1)
	kills_label.text = "Kills: %d" % data.get("kills", 0)
	var t = int(data.get("time", 0))
	time_label.text = "Time Survived: %s" % GameManager.format_time(t)
	var upg = data.get("upgrades", [])
	if upg.size() > 0:
		upgrades_label.text = "Upgrades:\n" + ", ".join(upg)
	else:
		upgrades_label.text = "Upgrades: None"

func _on_retry_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")

func _on_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
