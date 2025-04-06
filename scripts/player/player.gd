extends BaseCharacter

var firebolt_weapon_scene = preload("res://scenes/weapons/firebolt_weapon.tscn")
var upgrade_scene = preload("res://scenes/ui/upgrade_seletion.tscn")

@export var movement_speed = 100.0
@export var defense = 5
@export var xp = 0
@export var level = 1
var xp_to_next_level = 100
var weapon_manager

func _ready() -> void:
	weapon_manager = WeaponManager.new()
	add_child(weapon_manager)
	
	var projectile_weapon = firebolt_weapon_scene.instantiate()
	weapon_manager.add_weapon(projectile_weapon)
	projectile_weapon.attack_origin = global_position
	
func _physics_process(delta):
	movement()
	
	for weapon in weapon_manager.weapons:
		weapon.attack_origin = global_position
		
func movement():
	var x_mov = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_mov = Input.get_action_strength("move_down") - Input.get_action_strength("move_up") # up is minus and down is plus
	
	var mov = Vector2(x_mov, y_mov)
	
	velocity = mov.normalized() * movement_speed
	
	move_and_slide()

func gain_experience(amount) -> void:
	xp += amount
	if xp >= xp_to_next_level:
		level_up()

func level_up() -> void:
	level += 1
	xp -= xp_to_next_level
	xp_to_next_level = int(xp_to_next_level) * 1.2
	show_upgrade_selection() # to shwo updates
	
func show_upgrade_selection() -> void:
	var upgrade_ui = upgrade_scene.instantiate()
	get_tree().current_scene.get_node("UI").add_child(upgrade_ui)

	get_tree().paused = true
	upgrade_ui.show_menu()
