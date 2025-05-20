extends Area2D

@export var coin_value = 1

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body) -> void:
	if body.is_in_group("player"):
		GameManager.gain_coins(coin_value)
		queue_free()
