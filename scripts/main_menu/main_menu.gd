class_name MainMenu
extends Control

@onready var start_button = $MarginContainer/HBoxContainer2/VBoxContainer/Start_Button as Button
@onready var settings_button = $MarginContainer/HBoxContainer2/VBoxContainer/Settings_Button as Button
@onready var exit_button = $MarginContainer/HBoxContainer2/VBoxContainer/Exit_Button as Button
@onready var settings_menu = $settings_menu as SettingsMenu
@onready var margin_container = $MarginContainer as MarginContainer
@onready var shop_button = $MarginContainer/HBoxContainer2/VBoxContainer/Shop_Button as Button
@onready var sub_menu = $MarginContainer/HBoxContainer2/SubMenu

# to start preloading a test scene
@onready var start_level = preload("res://scenes/main/main.tscn") as PackedScene
@onready var shop_scene = preload("res://scenes/main_menu/ShopMenu.tscn") as PackedScene
@onready var setting_scene = preload("res://scenes/settings_menu/settings_menu.tscn") as PackedScene

var shop_instance = null
var settings_instance = null

func _ready():
	handle_signals()
	
	sub_menu.visible = false
	if settings_instance == null and settings_menu != null:
		settings_menu.visible = false
		settings_menu.set_process(false)

func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)

func on_exit_pressed() -> void:
	get_tree().quit()
	
func on_settings_pressed() -> void:
	if shop_instance != null:
		shop_instance.queue_free()
		shop_instance = null
		
	if settings_instance == null:
		settings_instance = setting_scene.instantiate() as Control
	
		if settings_menu != null:
			settings_menu.queue_free()
			settings_menu = null
	
		sub_menu.visible = true
		sub_menu.add_child(settings_instance)
	else:
		settings_instance.queue_free()
		settings_instance = null
		sub_menu.visible = false
		
func on_exit_settings_menu() -> void:
	if settings_instance != null:
		settings_instance.queue_free()
		settings_instance = null
	sub_menu.visible = false

func on_shop_pressed() -> void:
	if settings_instance != null:
		settings_instance.queue_free()
		settings_instance = null
		
	if shop_instance == null:
		shop_instance = shop_scene.instantiate() as Control
		sub_menu.visible = true
		sub_menu.add_child(shop_instance)
	else:
		shop_instance.queue_free()
		shop_instance = null
		sub_menu.visible = false
	
func handle_signals() -> void:
	start_button.button_down.connect(on_start_pressed)
	exit_button.button_down.connect(on_exit_pressed)
	settings_button.button_down.connect(on_settings_pressed)
	
	#settings_menu.exit_settings_menu.connect(on_exit_settings_menu)
	shop_button.button_down.connect(on_shop_pressed)
