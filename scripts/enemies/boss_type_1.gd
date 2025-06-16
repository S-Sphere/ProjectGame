extends BaseEnemy

enum State {
	CHASE,
	WARNING,
	CHARGE,
	IDLE
} 

@export var movement_speed = 30.0
@export var charge_speed = 250.0
@export var warning_time = 0.8
@export var time_between_charges = 5.0
@export var charge_width = 10.0

var state = State.CHASE
var _cooldown_timer: Timer
var _warning_timer: Timer
var _charge_timer: Timer

var player
var _charge_dir = Vector2.ZERO
var _charge_target = Vector2.ZERO

func _ready() -> void:
	max_health = 200
	health = max_health
	player = get_tree().get_first_node_in_group("player")
	
	_cooldown_timer = Timer.new()
	_cooldown_timer.wait_time = time_between_charges
	_cooldown_timer.one_shot = false
	add_child(_cooldown_timer)
	_cooldown_timer.timeout.connect(_on_cooldown_timeout)
	_cooldown_timer.start()
	
	_warning_timer = Timer.new()
	_warning_timer.wait_time = warning_time
	_warning_timer.one_shot = true
	add_child(_warning_timer)
	_warning_timer.timeout.connect(_end_charge)
	
	_charge_timer = Timer.new()
	_charge_timer.one_shot = true
	add_child(_charge_timer)
	_charge_timer.timeout.connect(_end_charge)

func _physics_process(delta):
	match state:
		State.CHASE:
			_chase_player(delta)
		State.WARNING:
			velocity = Vector2.ZERO
		State.CHARGE:
			_charge_move(delta)

func _chase_player(_delta) -> void:
	if player and is_instance_valid(player):
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * movement_speed
		move_and_slide()

func _on_cooldown_timeout() -> void:
	if player and is_instance_valid(player):
		state = State.WARNING
		_charge_target = player.global_position
		_charge_dir = global_position.direction_to(_charge_target)
		_warning_timer.start()
		queue_redraw()

func _start_charge() -> void:
	state = State.CHARGE
	var dist = global_position.distance_to(_charge_target)
	if dist <= 0:
		dist = 1
	var duration = dist / charge_speed
	_charge_timer.wait_time = duration
	_charge_timer.start()

func _charge_move(delta) -> void:
	velocity = _charge_dir * charge_speed
	move_and_slide()
	if player and is_instance_valid(player):
		if global_position.distance_to(player.global_position) <= 10:
			player.take_damage(dmg)

func _end_charge() -> void:
	state = State.CHASE
	queue_redraw()

func _draw() -> void:
	if state == State.WARNING:
		var start = Vector2.ZERO
		var end = to_local(_charge_target)
		var dir = (end - start).normalized()
		var normal = dir.orthogonal() * (charge_width / 2.0)
		var pts = [start - normal, start + normal, end + normal, end - normal]
		draw_polygon(pts, [Color(1, 0, 0.4)])
