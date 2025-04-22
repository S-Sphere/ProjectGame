extends CharacterBody2D
class_name BaseEnemy

@export var xp_drop_scene = preload("res://scenes/drops/XPDrop.tscn")
@export var max_health = 50
var health: int = max_health
@export var dmg: int = 10


func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		die()

func die() -> void:
	drop_xp()
	queue_free()
	
func drop_xp() -> void:
	var xp_drop = xp_drop_scene.instantiate()
	xp_drop.global_position = global_position # to drop at the right place
	get_tree().current_scene.call_deferred("add_child", xp_drop)
