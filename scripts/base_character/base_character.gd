extends CharacterBody2D

class_name BaseCharacter

@export var max_health = 250
var health = max_health
@export var dmg = 5
@export var defense = 2

func take_damage(amount) -> void:
	var final_amount = max(1, amount - defense)
	health -= final_amount
	print("%s took %d damage (defense %d), remaining health: %d" % [name, final_amount, defense, health])
	if health <= 0:
		die()

func die() -> void:
	queue_free()
