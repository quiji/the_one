extends KinematicBody2D

class_name CharacterBase

var state: CharacterActionStates
var body
var movement_velocity: Vector2

func _ready() -> void:
	
	
	for child in get_children():
		if child is CharacterActionStates:
			state = child
		elif child.has_method('isCharacterSpriteHandler'):
			body = child


	if not state:
		set_process(false)
		set_physics_process(false)


func _process(delta: float) -> void:

	state.run(delta)


func _physics_process(delta):

	move_and_slide(movement_velocity)

