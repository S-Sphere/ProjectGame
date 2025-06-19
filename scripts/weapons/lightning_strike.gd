# LightningStrike.gd
extends Node2D    # No longer Area2D unless you want AOE

@export var damage:       int   = 15
@export var fall_duration: float = 0.4
@export var spawn_height: float = 800.0

var target: Node  # assigned by the weapon

func _ready() -> void:
	# if the target’s gone, bail out
	if not target or not is_instance_valid(target):
		queue_free()
		return
	if GameManager.player != null:
		damage += GameManager.player.dmg
	# start well above the target
	global_position = target.global_position + Vector2(0, -spawn_height)

	# tween down
	var tw = create_tween()
	tw.tween_property(self, "global_position",
					  target.global_position,
					  fall_duration)
	tw.finished.connect(_on_strike_landed)
	print("  ↳ LightningStrike spawned above ", target)

func _on_strike_landed() -> void:
	if target and is_instance_valid(target) and target.has_method("take_damage"):
		target.take_damage(damage)
		print("  ↳ hit ", target, " for ", damage)
	queue_free()
