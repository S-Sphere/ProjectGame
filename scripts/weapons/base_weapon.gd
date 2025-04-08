extends Node2D

class_name Weapon
@export var cooldown = 1.0
@export var projectile_scene: PackedScene
@export var attack_origin: Vector2

var _fire_timer

func _ready() -> void:
	_fire_timer = Timer.new()
	_fire_timer.wait_time = cooldown
	_fire_timer.one_shot = false
	add_child(_fire_timer)
	_fire_timer.timeout.connect(fire)
	_fire_timer.start()
	

func fire() -> void:
	var projectile = projectile_scene.instantiate()
	projectile.is_homing = true
	projectile.global_position = attack_origin
	
	var enemies = get_tree().get_nodes_in_group("enemy")
	if enemies.size() > 0:
		var closest_enemy = enemies[0]
		var min_dist = attack_origin.distance_to(closest_enemy.global_position)
		for enemy in enemies:
			var dist = attack_origin.distance_to(enemy.global_position)
			if dist < min_dist:
				min_dist = dist
				closest_enemy = enemy
		projectile.target = closest_enemy
	else:
		return
	get_tree().current_scene.add_child(projectile)
