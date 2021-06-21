extends Control

class_name MovablePanels

onready var panels := {"cut": $CutPanel, "tower": $TowerPanel}

func _ready():
	for child in get_children():
		child.visible = false
		child.rect_position = Vector2.ZERO

func switch_panel(panel_name : String, show : bool, pos = Vector2.ZERO, center = false):
	panels[panel_name].visible = show
	if show:
		if center:
			panels[panel_name].rect_position = pos - panels[panel_name].rect_size / 2
		else:
			panels[panel_name].rect_position = pos

func is_panel_visible(panel_name : String):
	return panels[panel_name].visible
