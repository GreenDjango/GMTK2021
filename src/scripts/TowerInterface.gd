extends Node2D

class_name TowerInterface

var ref_cables : Array = []

func get_cablefix() -> Position2D:
	return get_node("CableFix") as Position2D
