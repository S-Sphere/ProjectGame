extends Resource
class_name Upgrade

# Baisc shit
@export var name: String
@export var description: String
@export var icon: Texture2D

@export var stat: String
@export var values: Array[float]


# if weapon
@export var weapon_scene: PackedScene
@export var max_level: int = 3

func amount_for(level: int) -> float:
	if values.is_empty():
		return 0.0
	var idx = clamp(level - 1, 0, values.size() - 1)
	return values[idx]
