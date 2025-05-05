extends Node2D

@export var width = 40
@export var height = 6
@export var y_offset = -20

var player

func _ready():
	player = get_parent()
	set_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	position = Vector2(0, y_offset)
	queue_redraw()
	
func _draw():
	if not player:
		return
	var ratio = clamp(player.health / float(player.max_health), 0.0, 1.0)
	draw_rect(Rect2(Vector2(-width/2, 0), Vector2(width, height)), Color(0,0,0,0.6))
	draw_rect(Rect2(Vector2(-width/2, 0), Vector2(width * ratio, height)), Color(1,0,0))
