extends CanvasLayer

@onready var coins_label = $ColorRect/VBoxContainer/CoinsLabel
@onready var level_label = $ColorRect/VBoxContainer/LevelLabel
@onready var kills_label = $ColorRect/VBoxContainer/KillsLabel
@onready var time_label = $ColorRect/VBoxContainer/TimeLabel
@onready var upgrades_label = $ColorRect/VBoxContainer/UpgradesLabel

@onready var resume_button = $ColorRect/VBoxContainer/Buttons/ResumeButton
@onready var retry_button = $ColorRect/VBoxContainer/Buttons/RetryButton
@onready var menu_button = $ColorRect/VBoxContainer/Buttons/MenuButton

func _ready():
	resume_button.pressed.connect(_on_resume_pressed)
	retry_button.pressed.connect(_on_retry_pressed)
	menu_button.pressed.connect(_on_menu_pressed)

func show_stats(data) -> void:
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

func _on_resume_pressed() -> void:
	GameManager.set_timer_visible(true)
	get_tree().paused = false
	queue_free()

func _on_retry_pressed() -> void:
	GameManager.reset_run_coins()
	GameManager.set_timer_visible(true)
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")

func _on_menu_pressed() -> void:
	GameManager.reset_run_coins()
	GameManager.set_timer_visible(true)
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
