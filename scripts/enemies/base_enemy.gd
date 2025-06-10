extends CharacterBody2D
class_name BaseEnemy

@export var xp_drop_scene = preload("res://scenes/drops/XPDrop.tscn")
@export var coin_drop_scene = preload("res://scenes/drops/CoinDrop.tscn")
@export var health_drop_scene = preload("res://scenes/drops/HealthDrop.tscn")

@export var max_health = 50
var health: int = max_health
@export var dmg: int = 10

@export_range(0.0, 1.0, 0.01) var xp_drop_rate = 0.70
@export_range(0.0, 1.0, 0.01) var coin_drop_rate = 0.10
@export_range(0.0, 1.0, 0.01) var health_drop_rate = 0.7

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		die()

func die() -> void:
	drop_loot()
	GameManager.incr_kills()
	queue_free()
	
func drop_loot() -> void:
	var r = randf()
	if r < xp_drop_rate:
		_spawn_drop(xp_drop_scene)
	elif r < xp_drop_rate + coin_drop_rate:
		_spawn_drop(coin_drop_scene)
	elif r < xp_drop_rate + coin_drop_rate + health_drop_rate:
		_spawn_drop(health_drop_scene)

func _spawn_drop(scene) -> void:
	var drop = scene.instantiate()
	drop.global_position = global_position
	get_tree().current_scene.call_deferred("add_child", drop)
