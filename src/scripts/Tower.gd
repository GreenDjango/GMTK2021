extends TowerInterface

class_name Tower

onready var sprite := $AnimatedSprite
onready var spark := $Spark

func _ready():
	sprite.play()
	spark.play()
