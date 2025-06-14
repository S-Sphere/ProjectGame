extends Node2D

@export var map_width = 1920
@export var map_height = 1080
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
	var tm = $TileMap/TileMapLayer_floor
	tm.clear()
	
	for x in range(int(-map_width/2), int(map_width/2)):
		for y in range(int(-map_height/2), int(map_height/2)):
			tm.set_cell(Vector2i(x, y), 0, Vector2i.ZERO)

func _build_walls() -> void:
	var tm = $TileMap/TileMapLayer2_wall
	tm.clear()
	
	for x in range(int(-map_width/2) - border_thickness, int(map_width/2) + border_thickness):
		for off in [-border_thickness, map_height/2]:
			tm.set_cell(Vector2i(x, -map_height/2 + off), 1, Vector2i.ZERO)
	for y in range(int(-map_height/2) - border_thickness, int(map_height/2) + border_thickness):
		for off in [-border_thickness, map_width/2]:
			tm.set_cell(Vector2i(-map_width/2 + off, y), 1, Vector2i.ZERO)
			
func _scatter_obstacles() -> void:
	var parent = $Obstacles
	if obstacle_scenes.is_empty():
		return
	for i in range(obstacle_count):
		var x = rng.randi_range(-map_width/2 + border_thickness, map_width/2 - border_thickness)
		var y = rng.randi_range(-map_height/2 + border_thickness, map_height/2 - border_thickness)
		var scene = obstacle_scenes[rng.randi_range(0, obstacle_scenes.size() - 1)]
		var obs = scene.instantiate() as Node2D
		var tile_size = $TileMap/TileMapLayer_floor.tile_set.tile_size
		var world_pos = $TileMap/TileMapLayer_floor.map_to_local(Vector2i(x,y)) + tile_size * 0.5
		obs.position = world_pos
		parent.add_child(obs)
