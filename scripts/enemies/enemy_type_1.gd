extends BaseEnemy

enum State {
	CHASE,
	ATTACK,
	IDLE
}

@export var movement_speed = 50.0
@export var attack_range = 0.0

var _player_col_shape
var state = State.CHASE

@onready var player = get_tree().get_first_node_in_group("player")
@onready var _col_shape = $CollisionShape2D
@onready var sprite: AnimatedSprite2D = $Sprite2D

func _ready() -> void:
	max_health = 60
	health = max_health
	if player and player.has_node("CollisionShape2D"):
		_player_col_shape = player.get_node("CollisionShape2D")
	
func _physics_process(delta):
	update_contact_cooldown(delta)
	match state:
		State.CHASE:
			chase_player(delta)
		State.ATTACK:
			attack_player(delta)
		State.IDLE:
			idle(delta)

func chase_player(_delta) -> void:
	if player and is_instance_valid(player):
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * movement_speed
		move_and_slide()
		sprite.play("run")
		sprite.flip_h = direction.x < 0
		if global_position.distance_to(player.global_position) <= _contact_threshold():
			state = State.ATTACK
	else:
		state = State.IDLE
	
func attack_player(_delta) -> void:
	if player and is_instance_valid(player):
		apply_contact_damage(player, dmg)
	sprite.play("attack")
	state = State.CHASE

func idle(_delta) -> void:
	velocity = Vector2.ZERO
	sprite.play("idle")
	if player and is_instance_valid(player):
		state = State.IDLE

func _shape_radius(shape):
	if shape is RectangleShape2D:
		return max(shape.extents.x, shape.extents.y)
	elif shape is CapsuleShape2D:
		return max(shape.radius, shape.height / 2.0)
	elif shape is CircleShape2D:
		return shape.radius
	return 0.0

func _contact_threshold():
	var r1 = 0.0
	if _col_shape and _col_shape.shape:
		r1 = _shape_radius(_col_shape.shape)
	var r2 = 0.0
	if _player_col_shape and _player_col_shape.shape:
		r2 = _shape_radius(_player_col_shape.shape)
	return attack_range + r1 + r2

func die() -> void:
	drop_loot()
	GameManager.incr_kills()
	if sprite.sprite_frames and sprite.sprite_frames.has_animation("death"):
		sprite.play("death")
		sprite.animation_finished.connect(queue_free)
	else:
		queue_free()
