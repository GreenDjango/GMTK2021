extends Node2D

class_name Cable

var from := Vector2() setget setFrom
var to := Vector2() setget setTo
var target : Node2D = null

func _process(_delat : float):
	if target && target.position != to:
		setTo(target.position)

func _draw():
	draw_line(from, to, Color.white, 1)

func setFrom(param : Vector2):
	from = param
	update()

func setTo(param : Vector2):
	to = param
	update()
