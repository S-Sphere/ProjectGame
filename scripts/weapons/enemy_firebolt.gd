extends Area2D

@export var speed: float = 350.0
@export var dmg: int = 10
@export var is_homing: bool = false
@export var max_lifetime = 2.0

var target: Node = null
var direction: Vector2 = Vector2.ZERO
var _age = 0.0
var _exploding = false

@onready var _sprite: AnimatedSprite2D = get_node_or_null("AnimatedSprite2D")
@onready var _collision: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))
	if _sprite:
		_sprite.play("move")

func _physics_process(delta: float) -> void:
	if _exploding:
		return
	_age += delta
	if _age >= max_lifetime:
		_explode()
		return
		
	if is_homing:
		if target and is_instance_valid(target):
			var move_dir = global_position.direction_to(target.global_position)
			rotation = move_dir.angle()
			global_position += move_dir * speed * delta
		else:
			queue_free()
	else:
		if direction != Vector2.ZERO:
			rotation = direction.angle()
			global_position += direction * speed * delta
		else:
			queue_free()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(dmg)
		_explode()

func _explode() -> void:
	if _exploding:
		return
	_exploding = true
	_collision.disabled = true
	if _sprite:
		_sprite.play("explode")
		await _sprite.animation_finished
	queue_free()
