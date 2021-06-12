extends KinematicBody2D

var velocity := Vector2.ZERO
const speed_max := 70.0
var acceleration := 0.1
const acceleration_step := 0.02
const friction := 020
var player_sprite: AnimatedSprite = null

func _ready():
	player_sprite = $Sprite

func _physics_process(_delta : float):
	var input := Vector2.ZERO
	if Input.is_action_pressed("right"):
		input.x += 1
	if Input.is_action_pressed("left"):
		input.x -= 1
	if Input.is_action_pressed("down"):
		input.y += 1
	if Input.is_action_pressed("up"):
		input.y -= 1
	_move_player(input.normalized())

func _move_player(input: Vector2):
	if input != Vector2.ZERO:
		if acceleration < 1:
			acceleration += acceleration_step
		player_sprite.play("run")
	else:
		if acceleration > 0.1:
			acceleration -= acceleration_step*2
		player_sprite.play("idle")

	if input.x != 0:
		velocity.x = input.x * speed_max * acceleration
		if velocity.x > 0:
			player_sprite.flip_h = true
		elif velocity.x < 0:
			player_sprite.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, friction)

	if input.y != 0:
		velocity.y = input.y * speed_max * acceleration
	else:
		velocity.y = move_toward(velocity.y, 0, friction)

	# warning-ignore:return_value_discarded
	move_and_slide(velocity)