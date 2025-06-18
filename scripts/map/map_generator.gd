extends Node2D

var map_width
var map_height
@export var map_size = 90
@export var border_thickness = 1

enum MapShape {SQUARE, CIRCLE, VERTICAL_CORRIDOR, HORIZONTAL_CORRIDOR}
var shape : MapShape
@export var obstacle_scenes = []
@export var obstacle_count = 50

var rng := RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
	_select_shape()
	_build_floor()
	_build_walls()
	_scatter_obstacles()

func _select_shape() -> void:
	var shapes = [
		MapShape.SQUARE, 
		MapShape.CIRCLE,
		MapShape.VERTICAL_CORRIDOR, 
		MapShape.HORIZONTAL_CORRIDOR
	]
	shape = shapes[rng.randi_range(0, shapes.size() - 1)]
	map_width = map_size
	map_height = map_size
	
	match shape:
		MapShape.VERTICAL_CORRIDOR:
			map_width = max(3, map_size / 3)
		MapShape.HORIZONTAL_CORRIDOR:
			map_height = max(3, map_size / 3)


func _build_floor() -> void:
	"""
	var tm = $TileMap/TileMapLayer_floor
	tm.clear()
	
	for x in range(int(-map_width/2), int(map_width/2)):
		for y in range(int(-map_height/2), int(map_height/2)):
			tm.set_cell(Vector2i(x, y), 0, Vector2i.ZERO)
	"""
	var tm = $TileMap/TileMapLayer_floor
	tm.clear()
	var radius = min(map_width, map_height) / 2
	for x in range(int(-map_width/2), int(map_width/2)):
		for y in range(int(-map_height/2), int(map_height/2)):
			var place = true
			if shape == MapShape.CIRCLE:
				var dist = Vector2(x + 0.5, y + 0.5).length()
				place = dist <= radius
			if place:
				tm.set_cell(Vector2i(x, y), 0, Vector2i.ZERO)

func _build_walls() -> void:
	"""
	var tm = $TileMap/TileMapLayer2_wall
	tm.clear()
	
	for x in range(int(-map_width/2) - border_thickness, int(map_width/2) + border_thickness):
		for off in [-border_thickness, map_height/2]:
			tm.set_cell(Vector2i(x, -map_height/2 + off), 1, Vector2i.ZERO)
	for y in range(int(-map_height/2) - border_thickness, int(map_height/2) + border_thickness):
		for off in [-border_thickness, map_width/2]:
			tm.set_cell(Vector2i(-map_width/2 + off, y), 1, Vector2i.ZERO)
	"""
	var tm = $TileMap/TileMapLayer2_wall
	tm.clear()
	if shape == MapShape.CIRCLE:
		var radius = min(map_width, map_height) / 2.0
		for x in range(int(-radius - border_thickness), int(radius + border_thickness)):
			for y in range(int(-radius - border_thickness), int(radius + border_thickness)):
				var dist = Vector2(x + 0.5, y + 0.5).length()
				if dist >= radius and dist < radius + border_thickness:
					tm.set_cell(Vector2i(x, y), 1, Vector2i.ZERO)
	else:
		var x_min = int(-map_width / 2)
		var x_max = int(map_width / 2) - 1
		var y_min = int(-map_height / 2)
		var y_max = int(map_height / 2) - 1
		for i in range(1, border_thickness + 1):
			for x in range(x_min - i, x_max + i + 1):
				tm.set_cell(Vector2i(x, y_min - i), 1, Vector2i.ZERO)
				tm.set_cell(Vector2i(x, y_max + i), 1, Vector2i.ZERO)
			for y in range(y_min - i, y_max + i + 1):
				tm.set_cell(Vector2i(x_min - i, y), 1, Vector2i.ZERO)
				tm.set_cell(Vector2i(x_max + i, y), 1, Vector2i.ZERO)

func _scatter_obstacles() -> void:
	"""
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
	"""
	var parent = $Obstacles
	if obstacle_scenes.is_empty():
		return
	var placed = 0
	var attempts = 0
	var tm = $TileMap/TileMapLayer_floor
	var tile_size = tm.tile_set.tile_size
	while placed < obstacle_count and attempts < obstacle_count * 10:
		attempts += 1
		var x = rng.randi_range(int(-map_width/2) + border_thickness, int(map_width/2) - border_thickness)
		var y = rng.randi_range(int(-map_height/2) + border_thickness, int(map_height/2) - border_thickness)
		if shape == MapShape.CIRCLE:
			var radius = min(map_width, map_height) / 2.0 - border_thickness
			if Vector2(x + 0.5, y + 0.5).length() > radius:
				continue
		var scene = obstacle_scenes[rng.randi_range(0, obstacle_scenes.size() - 1)]
		var obs = scene.instantiate() as Node2D
		var world_pos = tm.map_to_local(Vector2i(x, y)) + tile_size * 0.5
		obs.position = world_pos
		parent.add_child(obs)
		placed += 1
		
		
