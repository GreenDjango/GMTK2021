extends Node2D

class_name Tower

onready var spark := $Spark

func _ready():
	spark.play()
