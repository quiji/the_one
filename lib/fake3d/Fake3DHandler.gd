

const A_DEFAULT = Vector2(0, -1)
const B_DEFAULT = Vector2(0, -1)
const C_DEFAULT = Vector2(1, 0)
const PERSPECTIVE := Vector2(0.0, -1.0)

var direction_a = A_DEFAULT
var direction_b = B_DEFAULT
var direction_c = C_DEFAULT


var perspective_offset: float = 0.0
var use_perspective_offset: bool = false

var direction = Vector2()
var current_angle = 0
var b_dot = 0
var c_dot = 0

var layer_distance = 1.0

func set_direction_a(a):
	direction_a = a
	
func set_direction_b(b):
	direction_b = b

func set_direction_c(c):
	direction_c = c

func set_layer_distance(d):
	layer_distance = d

func reset_directions():
	direction_a = A_DEFAULT
	direction_b = B_DEFAULT
	direction_c = C_DEFAULT

func lerp_a(start_a, end_a, t):
	direction_a = Smoothstep.radial_interpolate(start_a, end_a, t)

func lerp_b(start_b, end_b, t):
	direction_b = Smoothstep.radial_interpolate(start_b, end_b, t)

func lerp_c(start_c, end_c, t):
	direction_c = Smoothstep.radial_interpolate(start_c, end_c, t)


func update_state() -> void:
	
	current_angle = direction_a.angle()

	"""
	Direction B handles x coordinate of pieces offset, and C handles the Y coordinate
	As the direction A changes, the offset changes in percentage from their given coordinates to the other,
	so using the respective y and x coordinates from Direction A as t on a lerp, we blend the coordinates
	dominance between directions B and C.

	"""
	
	var final_direction_b: Vector2 = direction_b
	var final_direction_c: Vector2 = direction_c
	
	var a_dot_for_c: float = direction_a.dot(PERSPECTIVE)
	var a_dot_for_b: float = direction_a.dot(-PERSPECTIVE.tangent())
	
	
	final_direction_c = final_direction_c.rotated(lerp(0.0, perspective_offset, a_dot_for_c))
	final_direction_b = final_direction_b.rotated(lerp(0.0, perspective_offset, a_dot_for_b))
	
	b_dot = final_direction_b.dot(B_DEFAULT)
	c_dot = final_direction_c.dot(C_DEFAULT)

	

	var direction_b_offset = Vector2(lerp(0, final_direction_b.x, direction_a.y), lerp(0, final_direction_b.x, -direction_a.x))
	var direction_c_offset = Vector2(lerp(0, final_direction_c.y, direction_a.x), lerp(0, final_direction_c.y, direction_a.y))

	direction = direction_b_offset + direction_c_offset
	
func get_b_dot() -> float:
	return b_dot

func get_c_dot() -> float:
	return c_dot

func get_layer_position(layer_id) -> Vector2:
	return Vector2(layer_distance * direction.x * layer_id, layer_distance * direction.y * layer_id)

func get_current_rotation() -> float:
	return current_angle + PI/2

func get_current_scale()  -> Vector2:
	return Vector2(b_dot, c_dot)

func get_current_z_index(total_layers, layer_id, offset: int = 0) -> int:

	# If upsidedown
	if (b_dot < 0 and c_dot >= 0) or (c_dot < 0 and b_dot >= 0):
		return total_layers - layer_id - 1 - offset
	else:
		return offset + layer_id

