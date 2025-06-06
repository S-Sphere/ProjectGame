# LightningWeapon.gd
extends Node2D
class_name LightningWeapon

@export var min_interval 	: float = 1.0
@export var max_interval 	: float = 3.0
@export var radius 		 	: float = 500.0
@export var lightning_scene : PackedScene
@export var attack_origin	: Vector2
var _timer: Timer

func _ready() -> void:
	randomize()
	add_to_group("origin_weapon")
	_timer = Timer.new()
	_timer.one_shot = true
	add_child(_timer)
	_timer.timeout.connect(_on_timer_timeout)
	_schedule_next_strike()
	print("⚡️ LightningWeapon ready at ", attack_origin, " radius=", radius)

func _schedule_next_strike() -> void:
	_timer.start(randf_range(min_interval, max_interval))
	print("  • Next strike in ", _timer.wait_time, "s")

func _on_timer_timeout() -> void:
	_fire_strike()
	_schedule_next_strike()

func _fire_strike() -> void:
	var center = attack_origin
	var candidates := []
	for e in get_tree().get_nodes_in_group("enemy"):
		if e.global_position.distance_to(center) <= radius:
			candidates.append(e)
	if candidates.is_empty():
		print("  • no enemies within ", radius, "px of ", center)
		return

	var target = candidates[randi() % candidates.size()]
	print("  • striking ", target, " at ", target.global_position)
	var bolt = lightning_scene.instantiate()
	# PASS THE NODE REFERENCE so the bolt can read it
	bolt.target = target
	get_tree().current_scene.add_child(bolt)
