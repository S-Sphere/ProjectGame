# PlayerRadialFirebolt.gd
extends Weapon
class_name RadialWeapon

# Number of projectiles fired for each weapon level.
@export var projectiles_per_level: int = 2
# Maximum projectiles regardless of level
@export var max_projectiles: int = 8
@export var speed: float = 400.0
@export var dmg: int = 10
#@export var is_homing: bool = false
#var target: Node = null
#var direction: Vector2 = Vector2.ZERO
#@export var projectile_scene = preload("res://scenes/weapons/firebolt_projectile.tscn")


func _ready() -> void:
	super._ready()

func fire() -> void:
        # Radial burst that scales with weapon level but caps at max_projectiles
        var total = min(projectiles_per_level * level, max_projectiles)
        var damage = dmg
        if level == 2:
                damage = int(dmg * 1.5)
        for i in range(total):
                var angle = TAU * i / total
                var dir = Vector2(cos(angle), sin(angle))
                var p = projectile_scene.instantiate()
                p.is_homing = false
                p.dmg = damage
                p.direction  = dir
                p.global_position = attack_origin
                get_tree().current_scene.add_child(p)
	# timer auto-repeats thanks to one_shot = false
