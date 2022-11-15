
signal animation_finished

class_name HandAnims


var t: float = 0.0
var current_state: Dictionary

var leftHand
var rightHand



func setup(newLeftHand, newRightHand) -> void:
	leftHand = newLeftHand
	rightHand = newRightHand

func setCurrentState(new_state: Dictionary) -> void:
	current_state = new_state.duplicate()
	current_state.old = {}
	t = 0.0

	for key in new_state:
		if not new_state[key] is Dictionary:
			continue 

		current_state.old[key] = {}

		var target

		if key == 'left':
			target = leftHand
		elif key == 'right':
			target = rightHand

		for innerKey in new_state[key]:
			if innerKey == 'position':
				current_state.old[key][innerKey].value = target.position
			elif innerKey == 'rotation':
				current_state.old[key][innerKey].value = target.rotation
	
func animate(leftHand, rightHand, delta) -> void:
	
	if current_state.empty():
		return

	if t < 1.0:
		t += delta / current_state.duration

		for key in current_state.old:
			var target 
			if key == 'left':
				target = leftHand
			elif key == 'right':
				target = rightHand
			
			for innerKey in current_state.old[key]:
				
				if innerKey == 'position':
					target.position = current_state.old[key][innerKey].linear_interpolate(current_state[key][innerKey], t)
				elif innerKey == 'rotation':
					target.rotation = lerp(current_state.old[key][innerKey], current_state[key][innerKey], t)
	
		leftHand.position
	else:
		current_state = {}
		emit_signal("animation_finished")
