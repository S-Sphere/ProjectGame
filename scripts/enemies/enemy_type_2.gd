extends BaseEnemy

@export var cooldown = 2.0
var shoot_timer
@export var projectile_speed = 400.0
@export var projectile_scene = preload("res://scenes/weapons/enemy_firebolt.tscn")

@onready var player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	max_health = 30
	health = max_health
	
	shoot_timer = Timer.new()
	shoot_timer.wait_time = cooldown
	shoot_timer.one_shot = false
	add_child(shoot_timer)
	shoot_timer.timeout.connect(shoot_at_player)
	shoot_timer.start()

# stupid, need to change this
func shoot_at_player() -> void:
	if player and is_instance_valid(player):
		var projectile = projectile_scene.instantiate()
		projectile.is_homing = false
		projectile.global_position = global_position
		var shoot_dir = (player.global_position - global_position).normalized()
		projectile.direction = shoot_dir
		get_tree().current_scene.add_child(projectile)


# Want to add a radius for the attack of the enemies to the player
# 2 ways of doing it:
# 	1) Using code, and then can use _draw to see it. 
#	2) USing the editor with a adding a 2D area, with a circle colision <-----
