extends Control

@onready var upgrade_1 = $HBoxContainer/Button
@onready var upgrade_2 = $HBoxContainer/Button2
@onready var upgrade_3 = $HBoxContainer/Button3

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = true
	handle_signals()

func handle_signals() -> void:
	upgrade_1.button_down.connect(_on_upgrade_1_pressed)
	upgrade_2.button_down.connect(_on_upgrade_2_pressed)
	upgrade_3.button_down.connect(_on_upgrade_3_pressed)

func _on_upgrade_1_pressed() -> void:
	print("Upgrade 1 selected")
	unpause_and_close()
	
func _on_upgrade_2_pressed() -> void:
	print("Upgrade 2 selected")
	unpause_and_close()
	
func _on_upgrade_3_pressed() -> void:
	print("Upgrade 3 selected")
	unpause_and_close()

func unpause_and_close() -> void:
	get_tree().paused = false
	queue_free()

func show_menu() -> void:
	visible = true
