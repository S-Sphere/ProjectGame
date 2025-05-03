extends Weapon

@export var speed: float = 400.0
@export var dmg: int = 10
@export var is_homing: bool = true
var target: Node = null
var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

func _physics_process(delta: float) -> void:
	if is_homing:
		if target and is_instance_valid(target):
			var move_dir = global_position.direction_to(target.global_position)
			rotation = move_dir.angle()
			global_position += move_dir * speed * delta
		#else:
			#queue_free()
	else:
		if direction != Vector2.ZERO:
			rotation = direction.angle()
			global_position += direction * speed * delta
		#else:
			#queue_free()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("enemy") and body.has_method("take_damage"):
		body.take_damage(dmg)
		queue_free()
