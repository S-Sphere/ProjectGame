extends BaseEnemy

@export var cooldown = 2.5
@export var projectile_scene = preload("res://scenes/weapons/enemy_firebolt.tscn")
@export var number_projectiles = 5

@onready var sprite: AnimatedSprite2D = $Sprite2D
@onready var attack_anim_timer: Timer = Timer.new()
@export var idle_anim = "idle"
@export var attack_anim = "attack"
@export var attack_anim_duration := 1.0

var shoot_timer

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

func shoot_radial() -> void:
	if sprite:
		sprite.play(attack_anim)
		attack_anim_timer.start()
	
	var angle_dif = TAU / number_projectiles # TAU -> 2*PI
	for i in range(number_projectiles):
		var angle = i * angle_dif
		var direction = Vector2(cos(angle), sin(angle))
		
		var projectile = projectile_scene.instantiate()
		projectile.is_homing = false
		projectile.global_position = global_position
		projectile.direction = direction
		get_tree().current_scene.add_child(projectile)

func _on_attack_anim_finished() -> void:
	if sprite:
		sprite.play(idle_anim)

func _start_shoot_timer() -> void:
	shoot_timer.wait_time = randf_range(cooldown * 0.5, cooldown * 3.5)
	shoot_timer.start()

func _on_shoot_timer_timeout() -> void:
	shoot_radial()
	_start_shoot_timer()
