tool
extends Node2D


func _ready():
	pass # Replace with function body.


func  _restartPositions() -> void:
	$left.position = Vector2(-12.0, 0.0)
	$right.position= Vector2(12.0, 0.0)

func _process(delta):

	var leftArm: Line2D = $left/leftArm.get_node($left/leftArm.remote_path)
	var rightArm: Line2D = $right/rightArm.get_node($right/rightArm.remote_path)

	leftArm.points[0] = Vector2.ZERO
	leftArm.points[1] = -leftArm.position * 0.2 + Vector2.UP * 4.0
	leftArm.points[2] = -leftArm.position + Vector2.UP * 6.0

	rightArm.points[0] = Vector2.ZERO
	rightArm.points[1] = -rightArm.position * 0.2 + Vector2.UP * 4.0
	rightArm.points[2] = -rightArm.position + Vector2.UP * 6.0

