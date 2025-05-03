extends Area2D

@export var xp_value = 100 # to be changed of course

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))


func _on_body_entered(body) -> void:
	if body.is_in_group("player"):
		GameManager.gain_experience(xp_value)
		queue_free()
