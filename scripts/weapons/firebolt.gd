extends Area2D

@export var speed = 400.0
@export var dmg = 10
var target = null

func _physics_process(delta):
	if target and is_instance_valid(target):
		var direction = global_position.direction_to(target.global_position)
		global_position += direction * speed * delta
		
		if global_position.distance_to(target.global_position) < 10.0:
			if target.has_method("take_damage"):
				target.take_damage(dmg)
			queue_free()
	else:
		queue_free()
