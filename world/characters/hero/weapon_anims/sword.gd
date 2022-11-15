
extends HandAnims

class_name SwordAnims

var is_first_state: bool 
var is_attacking: bool = false

var idle_state = {
	left = {
		position = {
			value = Vector2(-14.0, -8.0),
			method = 'stop2'
		},
		rotation = {
			value = -PI/6}
	},
	right = {
		position = {
			value = Vector2(-14.0, -4.0),
			method = 'stop2'
		},
		rotation = {
			value = -PI/6}
	},
	duration = 0.1,
	t = 0.0
}

var idle_state_2 = {
	left = {
		position = {
			value = Vector2(14.0, -8.0),
			method = 'stop2'
		},
		rotation = {
			value = PI/6}
	},
	right = {
		position = {
			value = Vector2(14.0, -4.0),
			method = 'stop2'
		},
		rotation = {
			value = PI/6}
	},
	duration = 0.1,
	t = 0.0
}

func idle() -> void:
	setCurrentState(idle_state)
	is_first_state = true


func attack() -> void:

	if is_first_state:
		setCurrentState(idle_state_2)
		is_first_state = false
	else:
		setCurrentState(idle_state)
		is_first_state = true

	is_attacking = true
	connect("animation_finished", self, "_onAnimationFinished", [], CONNECT_ONESHOT)

func _onAnimationFinished() -> void:
	is_attacking = false