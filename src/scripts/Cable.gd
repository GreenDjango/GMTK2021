extends Node2D

class_name Cable

var from := Vector2() setget setFrom, getFrom
var to := Vector2() setget setTo, getTo
var target : Node2D = null

var ref_in : Node2D = null
var ref_out : Node2D = null

func _process(_delat : float):
	if visible && target:
		setTo(target.global_position)

func _draw():
	draw_line(from, to, Color.black, 1)

func setFrom(param : Vector2):
	from = to_local(param)
	update()
	
func getFrom():
	return to_global(from)

func setTo(param : Vector2):
	to = to_local(param)
	update()

func getTo():
	return to_global(to)
