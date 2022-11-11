extends Node



static func iso_to_car(iso_vec: Vector2) -> Vector2:
	var result := Vector2()
	result.x = (iso_vec.x + iso_vec.y * 2.0) / 2.0
	result.y = -iso_vec.x + result.x
	
	return result

static func car_to_iso(vec: Vector2) -> Vector2:
	return Vector2(vec.x - vec.y , (vec.x + vec.y) / 2.0 )
