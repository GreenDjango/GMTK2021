extends Node2D

func _ready():
	pass

func _process(_delta : float):
	if Globals.is_debug:
		var process_time : float = Performance.get_monitor(Performance.TIME_PROCESS) * 1000
		var fps = Engine.get_frames_per_second()
		$CanvasLayer/DebugLabel.text = str(fps) + "fps " + str(process_time).pad_decimals(2) + "ms"
