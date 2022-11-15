extends Area2D


enum BulletTypes {Sword}

onready var sprite = $Sprite
var velocity: Vector2
func _ready():
	set_process(false)


func shoot(which:int, position: Vector2, direction: Vector2):
	
	global_position = position
	rotation = direction.angle() + PI/2.0
	velocity = direction * 300.0
	set_process(true)


func _process(delta):


	position += velocity * delta

