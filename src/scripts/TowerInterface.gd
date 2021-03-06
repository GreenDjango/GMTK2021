extends Node2D

class_name TowerInterface

var ref_cables := {}
var is_on := false

func get_cablefix() -> Position2D:
	return get_node("CableFix") as Position2D

func add_cable(cable : Node2D):
	ref_cables[cable.get_instance_id()] = cable

func remove_cable(cable : Node2D):
	# warning-ignore:return_value_discarded
	ref_cables.erase(cable.get_instance_id())

func is_link(tower : TowerInterface):
	for id in ref_cables:
		if tower.ref_cables.has(id):
			return true
	return false
