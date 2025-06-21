# LightningStrike.gd
extends Node2D    # No longer Area2D unless you want AOE

@export var damage:       int   = 15
@export var fall_duration: float = 1.0
@export var spawn_height: float = 400.0


var target: Node  # assigned by the weapon
var _start_y := 0.0
var _t := 0.0
var _damage_applied = false

@onready var _sprite = get_node_or_null("Sprite2D")

func _ready() -> void:
	# if the target’s gone, bail out
	if not target or not is_instance_valid(target):
		queue_free()
		return
		
	if GameManager.player != null:
		damage += GameManager.player.dmg
	
	var target_pos = target.global_position
	_start_y = target_pos.y - spawn_height
	global_position = target.global_position + Vector2(0, _start_y)

	if _sprite:
		_sprite.play("strike")
		_sprite.frame_changed.connect(_on_frame_changed)
		_sprite.frame_changed.connect(_on_animation_finished)

	print("  ↳ LightningStrike spawned above ", target)

func _on_frame_changed() -> void:
	var last = _sprite.sprite_frames.get_frame_count("strike")
	if _sprite.frame == last - 1:
		_apply_damage()

func _on_strike_landed() -> void:
	if target and is_instance_valid(target) and target.has_method("take_damage"):
		target.take_damage(damage)
		print("  ↳ hit ", target, " for ", damage)
	if not _sprite:
		queue_free()

func _process(delta) -> void:
	if not target or not is_instance_valid(target):
		queue_free()
		return

func _apply_damage() -> void:
	if _damage_applied:
		return
	_damage_applied = true
	if target and is_instance_valid(target) and target.has_method("take_damage"):
		target.take_damage(damage)
		print("  ↳ hit ", target, " for ", damage)

func _on_animation_finished() -> void:
	if not _damage_applied:
		_apply_damage()
	queue_free() 
