extends Resource
class_name Upgrade

# Baisc shit
@export var name: String
@export var description: String
@export var icon: Texture2D

@export var type: String # wheter is healht, dmg, weapon ...
@export var amount: float

# if weapon
@export var weapon_scene: PackedScene
