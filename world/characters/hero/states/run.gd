extends CharacterAction


func install() -> void:
	pass

func start(sub_state: String) -> void:
	actor.body.run()
	
func end(new_state: String) -> void:
	pass
	
func run(delta: float) -> void:
	
	
	var movement_direction: Vector2 = Vector2(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"), Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")).normalized()
	
	if movement_direction.length_squared() == 0.0:
		go_to("idle")
		return

	actor.movement_velocity = movement_direction * 70.0
	
	
func handle_input(event: InputEvent):
	pass
