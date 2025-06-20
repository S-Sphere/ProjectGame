extends Label

@export var float_speed = 40.0
@export var lifetime = 0.8

var _time = 0.0
var _amount := 0

func setup(amount) -> void:
	_amount = amount

func _ready() -> void:
	text = str(_amount)

func _process(delta) -> void:
	position.y -= float_speed * delta
	_time += delta
	modulate.a = 1.0 - clamp(_time / lifetime, 0.0, 1.0)
	if _time >= lifetime:
		queue_free()
