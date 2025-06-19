extends BaseEnemy

enum State {
	CHASE,
	ATTACK,
	IDLE
}

@export var movement_speed = 50.0
@export var attack_range = 20.0
var state = State.CHASE

@onready var player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	max_health = 60
	health = max_health
	
func _physics_process(delta):
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
		
		if global_position.distance_to(player.global_position) <= attack_range:
			state = State.ATTACK
	else:
		state = State.IDLE
	
func attack_player(_delta) -> void:
	if player and is_instance_valid(player):
		player.take_damage(dmg)
	state = State.CHASE

func idle(_delta) -> void:
	velocity = Vector2.ZERO
	if player and is_instance_valid(player):
		state = State.IDLE
