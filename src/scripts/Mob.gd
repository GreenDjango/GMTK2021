extends PathFollow2D

class_name Mob

var speed : float = 0 setget setSpeed
onready var mob_sprite := $Sprite

func _ready():
	setSpeed(0.05)
	mob_sprite.play()

func _physics_process(delta : float):
	if unit_offset < 1:
		unit_offset += speed * delta

func setSpeed(newSpeed : float):
	mob_sprite.frames.set_animation_speed("default", 2 + 200 * (newSpeed - 0.01))
	speed = newSpeed
