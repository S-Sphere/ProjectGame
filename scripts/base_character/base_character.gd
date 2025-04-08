extends CharacterBody2D

class_name BaseCharacter

@export var max_health = 1000
var health = max_health
@export var dmg = 10

func take_damage(amount) -> void:
	health -= amount
	print("Player took ", amount, " damage, remaining health: ", health)
	if health <= 0:
		die()

func die() -> void:
	queue_free()
