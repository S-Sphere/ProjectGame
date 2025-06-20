extends BaseEnemy

@export var cooldown = 3.0
var shoot_timer
@export var projectile_speed = 350.0
@export var projectile_scene = preload("res://scenes/weapons/enemy_firebolt.tscn")
@onready var sprite: AnimatedSprite2D = $Sprite2D
@onready var attack_anim_timer: Timer = Timer.new()
@export var idle_anim = "idle"
@export var attack_anim = "attack"
@export var attack_anim_duration := 0.6
@onready var player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	max_health = 60
	health = max_health
	
	if sprite:
		sprite.play(idle_anim)
		
	shoot_timer = Timer.new()
	shoot_timer.one_shot = true
	add_child(shoot_timer)
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)
	_start_shoot_timer()
	
	attack_anim_timer.one_shot = true
	attack_anim_timer.wait_time = attack_anim_duration
	add_child(attack_anim_timer)
	attack_anim_timer.timeout.connect(_on_attack_anim_finished)

# stupid, need to change this
func shoot_at_player() -> void:
	if player and is_instance_valid(player):
		if sprite:
			sprite.play(attack_anim)
			attack_anim_timer.start()

func _on_attack_anim_finished() -> void:
	if sprite:
		sprite.play(idle_anim)
	
	if player and is_instance_valid(player):
		var projectile = projectile_scene.instantiate()
		projectile.is_homing = false
		projectile.global_position = global_position
		var shoot_dir = (player.global_position - global_position).normalized()
		projectile.direction = shoot_dir
		get_tree().current_scene.add_child(projectile)
	_start_shoot_timer()

func _start_shoot_timer() -> void:
	shoot_timer.wait_time = randf_range(cooldown * 0.5, cooldown * 1.5)
	shoot_timer.start()

func _on_shoot_timer_timeout() -> void:
	shoot_at_player()
