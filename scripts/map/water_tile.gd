extends Node2D

class_name WaterTile

@export var sprite_frames: SpriteFrames
@export var animation: String = "water"

@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	if sprite_frames != null:
		_sprite.sprite_frames = sprite_frames
	if _sprite.sprite_frames != null:
		_sprite.play(animation)
