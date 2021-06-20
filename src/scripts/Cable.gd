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
	setRefIn(null)
	setRefOut(null)

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
	if ref_in && ref_in.has_method("remove_cable"):
		ref_in.remove_cable(self)
	if param && param.has_method("add_cable"):
		param.add_cable(self)
	ref_in = param

func setRefOut(param : Node2D):
	if ref_out && ref_out.has_method("remove_cable"):
		ref_out.remove_cable(self)
	if param && param.has_method("add_cable"):
		param.add_cable(self)
	ref_out = param
