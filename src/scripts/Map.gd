extends Node2D

class_name Map

onready var mob_paths := $MobPaths.get_children()

func _ready():
	pass

func get_cell(x: int, y: int) -> int:
	return $TileMap.get_cell(x, y)

func add_mob_on_random_path(mob : PathFollow2D):
	var rand_idx := randi() % mob_paths.size()
	mob_paths[rand_idx].add_child(mob)
