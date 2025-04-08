extends BaseEnemy

@export var cooldown = 2
@export var projectile_scene = preload("res://scenes/weapons/enemy_firebolt.tscn")
@export var number_projectiles = 8

var shoot_timer

func _ready() -> void:
	max_health = 30
	health = max_health
	
	shoot_timer = Timer.new()
	shoot_timer.wait_time = cooldown
	shoot_timer.one_shot = false
	add_child(shoot_timer)
	shoot_timer.timeout.connect(shoot_radial)
	shoot_timer.start()
	

func shoot_radial() -> void:
	# Math
	var angle_dif = TAU / number_projectiles # TAU -> 2*PI
	for i in range(number_projectiles):
		var angle = i * angle_dif
		var direction = Vector2(cos(angle), sin(angle))
		# --
		var projectile = projectile_scene.instantiate()
		projectile.is_homing = false
		projectile.global_position = global_position
		projectile.direction = direction
		get_tree().current_scene.add_child(projectile)
