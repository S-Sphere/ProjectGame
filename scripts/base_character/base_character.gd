extends CharacterBody2D

class_name BaseCharacter

@export var max_health = 1000
var health = max_health
@export var dmg = 10
@export var defense = 5

func take_damage(amount) -> void:
	var final_amount = max(1, amount - defense)
	health -= final_amount
	print("%s took %d damage (defense %d), remaining health: %d" % [name, final_amount, defense, health])
	if health <= 0:
		die()

func die() -> void:
	queue_free()
