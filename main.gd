extends Node





func _ready():
	
	OS.window_maximized = true

	SceneSwitcher.change_scene("res://world/prototype.tscn")
