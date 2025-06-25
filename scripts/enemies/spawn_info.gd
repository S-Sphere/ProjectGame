extends Resource

class_name SpawnInfo

@export var time_start			: int
@export var time_end			: int
@export var enemy				: PackedScene
@export var enemy_number		: int
@export var enemy_spawn_delay	: int
@export var override_health 	: int = -1
@export var override_dmg		: int = -1

var spawn_delay_counter = 0
