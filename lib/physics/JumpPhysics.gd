
extends Node
class_name JumpPhysics

#const INTERRUPT_THRESHOLD = 0.75
const INTERRUPT_MULTIPLIER = 1.8


export (float) var fall_velocity_limit = -1.0

var jump_delta := 0.0
var speed := 0.0
#var current_data : Dictionary
var current_data : Jump
#var jumps = []
var _current_gravity := 0.0
var falling := false
var gravity_modifier := 1.0 
var clamped_fall := false


func set_gravity_modifier(new_mod: float) -> void:
	gravity_modifier = new_mod
	
func restart_gravity_modifier() -> void:
	gravity_modifier = 1.0

func get_run_speedo(jump_id: String) -> float:
	if not has_node(jump_id):
		return 0.0
	
	return get_node(jump_id).run_speedo

func start(jump_id: String, jump_ratio : float = 1.0) -> float:
	if not has_node(jump_id):
		return 0.0
	
	clamped_fall = false
	jump_delta = 0.0
	current_data = get_node(jump_id)
	speed = -current_data.initial_speed * jump_ratio
	_current_gravity = current_data.jump_gravity
	falling = false
	return -current_data.initial_speed

func fall(jump_id: String, current_fall_speed : float = 0.0) -> void:
	if not has_node(jump_id):
		return

	clamped_fall = false
	jump_delta = 0.0
	speed = current_fall_speed
	current_data = get_node(jump_id)
	_current_gravity = current_data.fall_gravity
	falling = true

func get_fall_gravity(jump_id: String) -> float:
	if not has_node(jump_id):
		return 0.0

	return get_node(jump_id).fall_gravity

func process(delta) -> float:

	if not current_data:
		return 0.0

	if jump_delta > current_data.jump_time and not falling: 
		_current_gravity = current_data.fall_gravity
		falling = true
	
	speed -= _current_gravity * delta * gravity_modifier
	
	if fall_velocity_limit > 0.0 and falling and speed >= fall_velocity_limit:
		clamped_fall = true
		speed = fall_velocity_limit

	jump_delta += delta

	return speed

func reached_peak() -> bool:
	return jump_delta > current_data.jump_time

"""
func reaching_peak(percentage: float) -> bool:
	return (jump_delta / current_data.jump_time) > percentage
"""

func reaching_peak(time_to_peak: float) -> bool:
	return (current_data.jump_time - jump_delta) <= time_to_peak

func reached_fall_limit() -> bool:
	return clamped_fall

func interrupt(interrupt_factor: float = 0.5) -> void:
	#if jump_delta < current_data.jump_time * INTERRUPT_THRESHOLD:
		#jump_delta = current_data.jump_time * INTERRUPT_THRESHOLD
	speed *= interrupt_factor
	#_current_gravity = current_data.jump_gravity * INTERRUPT_MULTIPLIER
		#speed = current_data.initial_speed * (1.0 - INTERRUPT_THRESHOLD)
	
	

