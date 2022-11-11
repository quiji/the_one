shader_type canvas_item;
render_mode unshaded;

uniform float displacement = 0.0;
uniform float speed = 4.0;
uniform float amplitude = 1.0;
uniform float offset = 0.0;
uniform vec4 color : hint_color = vec4(1.0, 1.0, 1.0, 1.0);

uniform bool isometric = true;
uniform bool is_mouse_over = false;
uniform bool wave = false;
uniform bool modulate_color = false;

float lerp(float a, float b, float t) {
	return a + (b - a) * t;
}

void vertex() {
	//VERTEX += vec2(0.0, -2.0 * amplitude) * abs(sin( (TIME + displacement) * speed));
	vec2 vertex_offset = vec2(0.0, offset);

	
	if (is_mouse_over) {
		vertex_offset += vec2(0.0, -2.0 * amplitude * abs(sin( (TIME + displacement + 3.0) * speed + VERTEX.x)) * (sin( (TIME + displacement) * speed) + 1.0));
	}
	else if (wave) {
		if  (!isometric)
			vertex_offset += vec2(0.0, -1.0 * amplitude * sin( (TIME + displacement+ 2.0 + 2.0 * VERTEX.x) * speed + VERTEX.x));
		else
			//vertex_offset += vec2(0.0, -2.0 * amplitude * sin( (TIME  + displacement+ 2.0 + 2.0 * VERTEX.x * VERTEX.x * VERTEX.x) * speed +VERTEX.y*VERTEX.y));
			//6 5
			
			//vertex_offset += vec2(0.0, -1.0 * amplitude * sin( (TIME  + 4.0 * ( VERTEX.y* VERTEX.y)) )) * speed;
			//vertex_offset += vec2(0.0, -1.0 * amplitude * sin( (TIME  + 4.0 * (VERTEX.x * VERTEX.x * VERTEX.x)) )) * speed;
			vertex_offset += vec2(0.0, -1.0 * amplitude * sin( (TIME* speed  + displacement + 10.0) ) - 0.2) ;
	}

	
	VERTEX += vertex_offset;
}

void fragment() {
	float t = abs(sin( (TIME + displacement) * speed));
	vec4 col = texture(TEXTURE, UV);
	
	
	if (modulate_color && col.a > 0.4) {
		//vec4 multi_col = lerp(0.8, 2.0, t * t) * color;
		//multi_col.a = lerp(0.9, 1.0, t);
		//col *= multi_col;
		//col.rgb += color.rgb * 0.3;
		
		
		//t = lerp(1.05, 1.1, t);
		//col.rgb *= color.rgb * t* t* t* t;
		col.rgb = color.rgb *0.7 + col.rgb * color.rgb * 0.4 + col.rgb * 0.2;
		
		// Without glow:
		//col.a = 1.1;
		// With glow:
		//col.a = 1.1;
		col.rgb += vec3(0.1, 0.1, 0.1);
		col.a = 1.0;
	}
	
	
	// MOUSE OVER LAYER
	if (is_mouse_over && col.a > 0.4) {
		t = sin(TIME * 3.0);
		//col += vec4(0.14, 0.14, 0.14, 0.0) * t * t;
		
		
		
		
		// Without glow:
		//t = lerp(0.4, 1.0, t * t);
		//col += vec4(0.3, 0.3, 0.3, 0.2) * t * t;
		// With glow:
		//col += vec4(0.1, 0.1, 0.1, 0.8) * t * t;
		col += vec4(0.77, 0.77, 0.77, 0.0) * t * t;
		
	}
	
	
	
	COLOR = col;
	
}
