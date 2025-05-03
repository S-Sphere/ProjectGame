extends Resource
class_name Upgrade

# Baisc shit
@export var name: String
@export var description: String
@export var icon: Texture2D

@export var type: String # wheter is healht, dmg, weapon ...
@export var amounts: Array[float]


# if weapon
@export var weapon_scene: PackedScene
@export var max_level: int = 1

func amount_for(level: int) -> float:
	return amounts[min(level-1, amounts.size()-1)]
