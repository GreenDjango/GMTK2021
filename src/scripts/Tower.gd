extends TowerInterface

class_name Tower

onready var sprite := $AnimatedSprite
onready var spark := $Spark

func _ready():
	turn_off()

func turn_on():
	is_on = true
	sprite.play()
	spark.play()
	spark.visible = true

func turn_off():
	is_on = false
	sprite.stop()
	spark.stop()
	spark.visible = false
