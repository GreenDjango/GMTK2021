extends Node2D

func _ready():
	pass

func get_cell(x: int, y: int) -> int:
	return $TileMap.get_cell(x, y)
