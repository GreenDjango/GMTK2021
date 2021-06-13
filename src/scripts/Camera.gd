extends Camera2D

export(NodePath) var anchor_path
onready var anchor : Node2D = get_node(anchor_path) 
export(NodePath) var player_path
onready var player : Node2D = get_node(player_path)
const smooth_speed := 0.2

func _process(_delta : float):
	pass
	var target = player.global_position
	var target_pos = Vector2()
	target_pos.x = int(lerp(anchor.global_position.x, target.x, 1))
	target_pos.y = int(lerp(anchor.global_position.y, target.y, 1))
	anchor.global_position = target_pos
