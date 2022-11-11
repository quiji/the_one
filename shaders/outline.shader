shader_type canvas_item;

uniform bool buffed = false;
uniform vec4 buffed_color: hint_color;
uniform float outline_width = 2.0;
uniform vec4 outline_color: hint_color;
uniform bool selected = false;
uniform bool character = true;
uniform float flash = 0.0;

void fragment(){

    bool is_full_border = outline_width > 1.0;
	
    // Prepare outline and color modifications for buffed mode
	float final_width = outline_width;
	vec4 final_outline_color = outline_color;
	
	if (buffed) {
        float t = sin(TIME * 10.0);
        is_full_border = true;
		final_width = 3.0 + t;
		final_outline_color = buffed_color;// + vec4(0.4, 0.4, 0.4, 0.0) * abs(cos(TIME));
	}

    // Generate pixel perfect outline
    // Get pixel size
    float sprite_width = float(textureSize(TEXTURE, 0).x);
    float sprite_height = float(textureSize(TEXTURE, 0).y);
    float size_x = 1.0 / sprite_width;
    float size_y = 1.0 / sprite_height;
    vec4 sprite_color = texture(TEXTURE, UV);

    bool is_outline = false;
    for (float x = 0.0; (x <= final_width * size_x) && !is_outline; x += size_x) {

        for (float y = 0.0; (y <= final_width * size_y) && !is_outline; y += size_y) {
            

            vec2 direction = vec2(x * sprite_width , y * sprite_height);

            is_outline = is_outline || texture(TEXTURE, UV + vec2(x, y)).a > 0.5 && length(direction) <= final_width;
            is_outline = is_outline || texture(TEXTURE, UV + vec2(-x, y)).a > 0.5 && length(direction) <= final_width;
            is_outline = is_outline || texture(TEXTURE, UV + vec2(-x, -y)).a > 0.5 && length(direction) <= final_width;
            is_outline = is_outline || texture(TEXTURE, UV + vec2(x, -y)).a > 0.5 && length(direction) <= final_width;
        }

    }

    if (is_outline && sprite_color.a < 0.5) {
        COLOR = final_outline_color;
    }
    else {

		if (selected) {
			float factor = abs(sin(TIME * 2.0));
			sprite_color -= vec4(0.1* factor, 0.1  * factor, 0.2 * factor , 0.0);
		}
		if (character) {
			sprite_color.rgb += vec3(0.05, 0.05, 0.05);
			sprite_color.rgb += vec3(0.05, 0.05, 0.05);
			//
		}
        if (buffed) {
            sprite_color.rgb += buffed_color.rgb * abs(sin(TIME * 2.0));
            
        }
        sprite_color = mix(sprite_color, vec4(0.8, 0.8, 0.8, sprite_color.a), flash);
        
        COLOR = sprite_color;
    }
	
}