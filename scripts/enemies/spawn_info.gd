extends Resource

class_name SpawnInfo

@export var time_start			: int
@export var time_end			: int
@export var enemy				: PackedScene
@export var enemy_number		: int
@export var enemy_spawn_delay	: int

var spawn_delay_counter = 0
