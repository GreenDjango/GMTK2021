extends Node2D

export(PackedScene) var mob_scene

func _ready():
	# print($Map.get_cell(1,1))
	pass

func _process(_delta : float):
	if Globals.is_debug:
		var process_time : float = Performance.get_monitor(Performance.TIME_PROCESS) * 1000
		var fps = Engine.get_frames_per_second()
		$CanvasLayer/DebugLabel.text = str(fps) + "fps " + str(process_time).pad_decimals(2) + "ms"

func _input(event : InputEvent):
	if event.is_action_pressed("ui_accept"):
		spawn_mob()

func spawn_mob():
	var scene : Node2D = mob_scene.instance()
	rand_range(0, 10)
	scene.position = Vector2(160 + rand_range(0, 20), 100 + rand_range(0, 10))
	$YSort.add_child(scene)
