# PlayerRadialFirebolt.gd
extends Weapon
class_name RadialWeapon

@export var number_projectiles: int = 8
@export var speed: float = 400.0
@export var dmg: int = 10
#@export var is_homing: bool = false
#var target: Node = null
#var direction: Vector2 = Vector2.ZERO
#@export var projectile_scene = preload("res://scenes/weapons/firebolt_projectile.tscn")


func _ready() -> void:
	super._ready()

func fire() -> void:
	# radial burst instead of homing
	for i in range(number_projectiles):
		var angle = TAU * i / number_projectiles
		var dir = Vector2(cos(angle), sin(angle))
		var p = projectile_scene.instantiate()
		p.is_homing = false
		p.direction  = dir
		p.global_position = attack_origin
		get_tree().current_scene.add_child(p)
	# timer auto-repeats thanks to one_shot = false
