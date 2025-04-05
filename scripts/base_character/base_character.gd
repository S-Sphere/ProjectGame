extends CharacterBody2D

class_name BaseCharacter

@export var max_health = 100
var health = max_health
@export var dmg = 10

func take_damage(amount) -> void:
	health -= amount
	if health <= 0:
		die()

func die() -> void:
	queue_free()
