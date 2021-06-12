extends Node

var default_life := 3.0
var life := default_life
var is_debug : bool = OS.is_debug_build()

func _ready():
	randomize()

func restart_game():
	life = default_life
	goto_scene("main_menu")

func goto_scene(new_scene_name : String):
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://src/scenes/" + new_scene_name + ".tscn")
