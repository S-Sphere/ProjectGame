# LightningStrike.gd
extends Node2D    # No longer Area2D unless you want AOE

@export var damage:       int   = 15
@export var fall_duration: float = 0.1
@export var spawn_height: float = 150.0

@export var fall_animation = "fall"
@export var explode_animation = "explode"

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
	global_position = Vector2(target_pos.x, _start_y)

	if _sprite:
		_sprite.play(fall_animation)
		_sprite.animation_finished.connect(_on_animation_finished)
	print("  ↳ LightningStrike spawned above ", target)

func _process(delta) -> void:
	if not target or not is_instance_valid(target):
		queue_free()
		return
	_t += delta
	var target_pos = target.global_position
	var start_pos = Vector2(target_pos.x, target_pos.y - spawn_height)
	var t = clamp(_t / fall_duration, 0.0, 1.0)
	global_position = start_pos.lerp(target_pos, t)

func _apply_damage() -> void:
	if _damage_applied:
		return
	_damage_applied = true
	if target and is_instance_valid(target) and target.has_method("take_damage"):
		target.take_damage(damage)
		print("  ↳ hit ", target, " for ", damage)

func _on_animation_finished() -> void:
	if not _sprite:
		queue_free()
		return
	if _sprite.animation == fall_animation:
		_apply_damage()
		_sprite.play(explode_animation)
	else:
		if not _damage_applied:
			_apply_damage()
		queue_free() 
