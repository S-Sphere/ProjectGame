extends CharacterBody2D

var movement_speed = 100.0

func _physics_process(delta):
	movement()
	
	
func movement():
	var x_mov = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_mov = Input.get_action_strength("move_down") - Input.get_action_strength("move_up") # up is minus and down is plus
	
	var mov = Vector2(x_mov, y_mov)
	
	velocity = mov.normalized() * movement_speed
	
	move_and_slide()
