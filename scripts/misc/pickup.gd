extends Area2D

@export var pickup_type : String	# "xp", "coin", "health"
@export var value 		: int

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body) -> void:
	if not body.is_in_group("player"):
		return
	
	match pickup_type:
		"xp":
			GameManager.gain_experience(value)
		"coin":
			GameManager.gain_coins(value)
		"health":
			GameManager.heal_player(value)
	
	queue_free()
