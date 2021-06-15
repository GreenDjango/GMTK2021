extends Node2D

class_name Cable

var from := Vector2.ZERO setget setFrom, getFrom
var to := Vector2.ZERO setget setTo, getTo
var target : Node2D = null

var ref_in : Node2D = null setget setRefIn
var ref_out : Node2D = null setget setRefOut

func _process(_delat : float):
	if visible && target:
		setTo(target.global_position)

func _draw():
	draw_line(from, to, Color.black, 1)

func reset():
	setFrom(Vector2.ZERO)
	setTo(Vector2.ZERO)
	target = null
	ref_in = null
	ref_out = null

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

func setRefIn(param : Node2D):
	if "ref_cables" in param && param.ref_cables is Array:
		param.ref_cables.push_back(self)
	ref_in = param

func setRefOut(param : Node2D):
	if "ref_cables" in param && param.ref_cables is Array:
		param.ref_cables.push_back(self)
	ref_out = param
