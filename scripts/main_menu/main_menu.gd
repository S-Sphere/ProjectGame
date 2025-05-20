class_name MainMenu
extends Control

@onready var start_button = $MarginContainer/HBoxContainer/VBoxContainer/Start_Button as Button
@onready var settings_button = $MarginContainer/HBoxContainer/VBoxContainer/Settings_Button as Button
@onready var exit_button = $MarginContainer/HBoxContainer/VBoxContainer/Exit_Button as Button
@onready var settings_menu = $settings_menu as SettingsMenu
@onready var margin_container = $MarginContainer as MarginContainer
@onready var shop_button = $MarginContainer/HBoxContainer/VBoxContainer/Shop_Button as Button
# to start preloading a test scene
@onready var start_level = preload("res://scenes/main/main.tscn") as PackedScene
@onready var shop_scene = preload("res://scenes/main_menu/ShopMenu.tscn") as PackedScene



func _ready():
	handle_signals()

func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)

func on_exit_pressed() -> void:
	get_tree().quit()
	
func on_settings_pressed() -> void:
	print("LOAD SETTINGS MENU")
	margin_container.visible = false
	settings_menu.set_process(true)
	settings_menu.visible = true
	
func on_exit_settings_menu() -> void:
	margin_container.visible = true
	settings_menu.visible = false

func on_shop_pressed() -> void:
	var shop = shop_scene.instantiate()
	add_child(shop)
	
func handle_signals() -> void:
	start_button.button_down.connect(on_start_pressed)
	exit_button.button_down.connect(on_exit_pressed)
	settings_button.button_down.connect(on_settings_pressed)
	settings_menu.exit_settings_menu.connect(on_exit_settings_menu)
	shop_button.button_down.connect(on_shop_pressed)
