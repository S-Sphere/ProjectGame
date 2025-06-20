#player.gd
extends BaseCharacter
# I NEED TO CHANGE THIS:
# REALLY!!!!! CREATE A GAME MANAGER AT SOME POINT -> done

#var firebolt_weapon_scene = preload("res://scenes/weapons/firebolt_weapon.tscn")
# for the initial weapon
@export var starting_upgrade: Upgrade
@export var movement_speed = 80.0
@export var magnet_range = 0.0
@export var magnet_speed = 150.0
var weapon_manager

@onready var sprite: AnimatedSprite2D = $Sprite2D
func _ready() -> void:
	GameManager.register_player(self)
	
	weapon_manager = WeaponManager.new()
	add_child(weapon_manager)
	
	GameManager.upgrade_levels.clear()
	GameManager.upgrade_levels[starting_upgrade.stat + starting_upgrade.weapon_scene.resource_path] = 1
	GameManager._apply_upgrade(starting_upgrade, 1)
	#var projectile_weapon = firebolt_weapon_scene.instantiate()
	#weapon_manager.add_weapon(projectile_weapon)
	#projectile_weapon.attack_origin = global_position
	
func _physics_process(_delta):
	movement()
	weapon_manager.update_origins(global_position)
	_magnet_pull(_delta)

func movement():
	var x_mov = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_mov = Input.get_action_strength("move_down") - Input.get_action_strength("move_up") # up is minus and down is plus
	var mov = Vector2(x_mov, y_mov)
	velocity = mov.normalized() * movement_speed
	if mov != Vector2.ZERO:
		sprite.play("run")
		sprite.flip_h = x_mov < 0
	else:
		sprite.stop()
	
	move_and_slide()

func _magnet_pull(delta) -> void:
	if magnet_range <= 0:
		return
	for p in get_tree().get_nodes_in_group("pickup"):
		if not p.is_inside_tree():
			continue
		if global_position.distance_to(p.global_position) <= magnet_range:
			p.global_position = p.global_position.move_toward(global_position, magnet_speed * delta)
func _on_enemy_defeated(xp_amount) -> void:
	GameManager.gain_experience(xp_amount)

func die() -> void:
	GameManager.end_run()
	super.die()
