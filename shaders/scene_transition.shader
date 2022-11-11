shader_type canvas_item;

uniform bool invert  = false;
uniform float block : hint_range(0.0, 1.0) = 0.0 ;
uniform vec4 block_color : hint_color = vec4(0.0, 0.0, 0.0, 0.0);

void fragment() {
	float block_factor = block;
	if (invert) {
		block_factor = 1.0 - block;
	}
	
	vec4 result = vec4(0.0, 0.0, 0.0, 0.0);
	vec2 pos = vec2(UV.x - block_factor*block_factor, UV.y);
	bool is_blackened_pixel = pos.x < (1.0 - (pos.y)) * block_factor * 2.0;
	
	if ((!invert && is_blackened_pixel) || (invert && !is_blackened_pixel)) {
		result = block_color;
	}
	
	
	COLOR = result;
	
}