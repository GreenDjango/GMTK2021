extends Node2D

export(PackedScene) var mob_scene
export(PackedScene) var cable_scene
onready var player := $YSort/Player
onready var castle := $YSort/Castle
onready var cables := $Cables
onready var cable := $Cables/MainCable

func _ready():
	$CanvasLayer/DebugLabel.visible = Globals.is_debug
	# print($Map.get_cell(1,1))
	pass

func _process(_delta : float):
	if Globals.is_debug:
		var process_time : float = Performance.get_monitor(Performance.TIME_PROCESS) * 1000
		var fps = Engine.get_frames_per_second()
		$CanvasLayer/DebugLabel.text = str(fps) + "fps " + str(process_time).pad_decimals(2) + "ms"

func _input(event : InputEvent):
	if event.is_action_pressed("ui_accept"):
		var nearbyTowers : Array = player.get_nearby_towers()
		if player.is_grab && nearbyTowers.size():
			if nearbyTowers.size():
				var tower : Tower = nearbyTowers[0]
				var new_cable : Cable = cable_scene.instance()
				cables.add_child(new_cable)
				new_cable.from = castle.global_position
				new_cable.to = tower.get_node("CableFix").global_position
				release_cable()
		else:
			grab_cable(castle.global_position)

func release_cable():
	cable.visible = false
	player.is_grab = false

func grab_cable(from : Vector2):
	cable.from = from
	cable.target = player
	player.is_grab = true
	cable.visible = true

func put_cable(from : Vector2, to : Vector2):
	cable.from = from
	cable.to = to

func spawn_mob():
	var scene : Node2D = mob_scene.instance()
	scene.position = Vector2(160 + rand_range(0, 20), 100 + rand_range(0, 10))
	$YSort.add_child(scene)
