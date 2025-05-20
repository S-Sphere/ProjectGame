extends Area2D

@export var health_value = 10

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body) -> void:
	if body.is_in_group("player"):
		GameManager.heal_player(health_value)
		queue_free()
