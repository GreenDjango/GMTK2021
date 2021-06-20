extends Node2D

export(PackedScene) var mob_scene
export(PackedScene) var cable_scene
onready var player := $YSort/Player
onready var castle := $YSort/Castle
onready var cables := $Cables
onready var main_cable := $MainCable
var active_cable : Cable = null

func _ready():
	$CanvasLayer/DebugLabel.visible = Globals.is_debug
	# print($Map.get_cell(1,1))
	pass

func _process(_delta : float):
	if Globals.is_debug:
		var process_time : float = Performance.get_monitor(Performance.TIME_PROCESS) * 1000
		var fps = Engine.get_frames_per_second()
		$CanvasLayer/DebugLabel.text = str(fps) + "fps " + str(process_time).pad_decimals(2) + "ms"

func _physics_process(_delta : float):
	active_cable = null
	var cable_info = {"distance": INF}
	for cable in cables.get_children():
		var section = is_under_cable(cable.from, cable.to, player.action_shape)
		if section && section["distance"] < cable_info["distance"]:
			cable_info = section
			active_cable = cable

	if !active_cable:
		$Message.visible = false
	else:
		$Message.text = 'Cut'
		$Message.rect_position = cable_info["cross_point"]
		$Message.visible = true

func _input(event : InputEvent):
	if event.is_action_pressed("ui_accept"):
		var nearbyTowers : Array = player.get_nearby_towers()
		var tower : Node2D = nearbyTowers.pop_back()
		if player.is_grab && tower && tower != main_cable.ref_in:
			put_cable(tower)
		elif !player.is_grab && tower:
			grab_cable(tower)
	if event.is_action_pressed("cut"):
		if active_cable:
			# TODO: erase cable ref in towers
			print(active_cable.ref_in, active_cable.ref_out)
			active_cable.queue_free()

func grab_cable(tower : Node2D):
	main_cable.from = tower.get_cablefix().global_position
	main_cable.target = player
	main_cable.ref_in = tower
	main_cable.ref_out = player
	main_cable.visible = true
	player.is_grab = true

func put_cable(tower : Node2D):
	var new_cable : Cable = cable_scene.instance()
	cables.add_child(new_cable)
	new_cable.from = main_cable.from
	new_cable.to = tower.get_cablefix().global_position
	new_cable.ref_in = main_cable.ref_in
	new_cable.ref_out = tower
	release_cable()

func release_cable():
	main_cable.reset()
	main_cable.visible = false
	player.is_grab = false

func is_under_cable(cable_start : Vector2, cable_end : Vector2, player_area : CollisionShape2D):
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
	var radius : float = player_area.shape.radius
	
	if A.x + radius < B.x && A.x + radius < C.x:
		return false
	if A.x - radius > B.x && A.x - radius > C.x:
		return false
	if A.y + radius < B.y && A.y + radius < C.y:
		return false
	if A.y - radius > B.y && A.y - radius > C.y:
		return false

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

	if (AD_side <= radius):
		var cross_point = Vector2()
		cross_point.x = A.x
		# Point-Slope Equation of a Line: y = m(x − x1) + y1
		cross_point.y = (BC.y / BC.x ) * (A.x - B.x) + B.y
		return {"cross_point": cross_point, "distance": AD_side}
	return false


func spawn_mob():
	var scene : Node2D = mob_scene.instance()
	scene.position = Vector2(160 + rand_range(0, 20), 100 + rand_range(0, 10))
	$YSort.add_child(scene)
