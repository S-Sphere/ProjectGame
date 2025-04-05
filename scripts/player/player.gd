extends BaseCharacter

@export var firebolt_weapon_scene = preload("res://scenes/weapons/firebolt_weapon.tscn")
@export var movement_speed = 100.0

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
