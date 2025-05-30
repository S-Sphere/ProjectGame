extends Node2D

@export var map_width = 80
@export var map_height = 60
@export var border_thickness = 1

@export var obstacle_scenes = []
@export var obstacle_count = 50

var rng := RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
	_build_floor()
	_build_walls()
	_scatter_obstacles()

func _build_floor() -> void:
	var tm = $TileMapLayer_floor
	tm.clear()
	
	for x in range(int(-map_width/2), map_width):
		for y in range(int(-map_height/2), map_height):
			tm.set_cell(Vector2i(x, y), 0)

func _build_walls() -> void:
	var tm = $TileMapLayer2_wall
	tm.clear()
	
	for x in range(int(-map_width/2) - border_thickness, int(map_width/2) + border_thickness):
		for off in [-border_thickness, map_height/2]:
			tm.set_cell(Vector2i(x, -map_height/2 + off), 0)
	for y in range(int(-map_height/2) - border_thickness, int(map_height/2) + border_thickness):
		for off in [-border_thickness, map_width/2]:
			tm.set_cell(Vector2i(-map_width/2 + off, y), 0)
			
func _scatter_obstacles() -> void:
	var parent = $Obstacles
	if obstacle_scenes.is_empty():
		return
	for i in range(obstacle_count):
		var x = rng.randi_range(-map_width/2 + border_thickness, map_width/2 - border_thickness)
		var y = rng.randi_range(-map_height/2 + border_thickness, map_height/2 - border_thickness)
		var scene = obstacle_scenes[rng.randi_range(0, obstacle_scenes.size() - 1)]
		var obs = scene.instantiate() as Node2D
		var world_pos = $TileMapLayer_floor.map_to_world(Vector2(x,y)) + $TileMapLayer_floor.cell_size * 0.5
		obs.position = world_pos
		parent.add_child(obs)
