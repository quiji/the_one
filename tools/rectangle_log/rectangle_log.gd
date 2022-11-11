extends Node2D

var current_rect: Rect2
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func log_rect(rect: Rect2) -> void:
	
	current_rect = rect
	update()
	
	
func _draw():
	
	draw_rect(current_rect, Color(1.0, 1.0, 1.0, 1.0), false)
	
