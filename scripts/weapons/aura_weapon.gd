extends Area2D
class_name AuraWeapon

@export var base_radius = 50.0
@export var radius_per_level = 20.0
@export var base_damage = 5
@export var damage_per_level = 5
@export var tick_rate = 0.5
@export var attack_origin: Vector2 = Vector2.ZERO

@onready var collision_shape_2d = $CollisionShape2D
@onready var _timer: Timer = Timer.new()

var _shape = CircleShape2D
var level: int = 1 : set = set_level
var damage
var range
 
func _ready() -> void:
	add_to_group("origin_weapon")
	_shape = collision_shape_2d.shape as CircleShape2D
	add_child(_timer)
	_timer.wait_time = tick_rate
	_timer.one_shot = false
	_timer.timeout.connect(_on_tick)
	_timer.start()
	
	update_stats()
	
func _process(_delta) -> void:
	global_position = attack_origin

func set_level(value) -> void:
	level = value
	update_stats()

func update_stats() -> void:
	var r = base_radius + radius_per_level * (level - 1)
	damage = base_damage + damage_per_level * (level - 1)
	range = r
	if _shape:
		_shape.radius = r
	queue_redraw()
	
func _draw() -> void:
	draw_circle(Vector2.ZERO, _shape.radius, Color(1,0,0,0.4))
	
func _on_tick() -> void:
	for body in get_overlapping_bodies():
		if body.is_in_group("enemy") and body.has_method("take_damage"):
			body.take_damage(damage)
