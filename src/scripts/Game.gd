extends Node2D

export(PackedScene) var mob_scene
export(PackedScene) var cable_scene
onready var player := $YSort/Player
onready var castle := $YSort/Castle
onready var cables := $Cables
onready var main_cable := $MainCable

func _ready():
	$CanvasLayer/DebugLabel.visible = Globals.is_debug
	# print($Map.get_cell(1,1))
	pass

func _process(_delta : float):
	if Globals.is_debug:
		var process_time : float = Performance.get_monitor(Performance.TIME_PROCESS) * 1000
		var fps = Engine.get_frames_per_second()
		$CanvasLayer/DebugLabel.text = str(fps) + "fps " + str(process_time).pad_decimals(2) + "ms"
	var find_cable := false
	for cable in cables.get_children():
		var section = is_under_cable(cable.from, cable.to, player.action_shape)
		if section:
			$Message.text = 'Cut'
			$Message.rect_position = player.global_position - $Message.rect_size / 2
			$Message.visible = true
			find_cable = true
			break
	if !find_cable:
		$Message.visible = false
	# $Sprite.visible = find_cable

func _input(event : InputEvent):
	if event.is_action_pressed("ui_accept"):
		var nearbyTowers : Array = player.get_nearby_towers()
		var tower : Node2D = nearbyTowers.pop_back()
		if player.is_grab && tower:
			var new_cable : Cable = cable_scene.instance()
			cables.add_child(new_cable)
			new_cable.from = main_cable.from
			new_cable.to = tower.get_node("CableFix").global_position
			release_cable()
		elif !player.is_grab && tower:
			grab_cable(tower.get_node("CableFix").global_position)

func release_cable():
	main_cable.visible = false
	player.is_grab = false

func grab_cable(from : Vector2):
	main_cable.from = from
	main_cable.target = player
	player.is_grab = true
	main_cable.visible = true

func put_cable(from : Vector2, to : Vector2):
	main_cable.from = from
	main_cable.to = to

func is_under_cable(cable_start : Vector2, cable_end : Vector2, player_area : CollisionShape2D) -> bool:
	#      A: circle
	#      /      |
	#     /       |
	#    /        |
	# B: start __ D: ??? _____ C: end
	# ABD is right angle in D
	# https://math.stackexchange.com/questions/361412/finding-the-angle-between-three-points
	# https://stackoverflow.com/a/1079478

	var A : Vector2 = player_area.global_position
	var B : Vector2 = cable_start
	var C : Vector2 = cable_end

	var AB := B - A
	var BC := C - B
	var AB_side = sqrt(pow(AB.x, 2) + pow(AB.y, 2))
	var BC_side = sqrt(pow(BC.x, 2) + pow(BC.y, 2))
	var dot_prod := abs(AB.x * BC.x + AB.y * BC.y)

	# AB→⋅BC→ = ∥AB→∥∥BC→∥cosθ
	# so θ = acos( AB→⋅BC→ / ∥AB→∥∥BC→∥ )
	# where θ is B angle, AB→⋅BC→ scalar product, ∥∗∥ measures the length (s)
	var zeta = acos(dot_prod / (AB_side * BC_side))
	var AD_side = sin(zeta) * AB_side

	return (AD_side <= player_area.shape.radius)


func spawn_mob():
	var scene : Node2D = mob_scene.instance()
	scene.position = Vector2(160 + rand_range(0, 20), 100 + rand_range(0, 10))
	$YSort.add_child(scene)
