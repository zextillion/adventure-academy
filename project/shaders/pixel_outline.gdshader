shader_type canvas_item;

uniform vec4 outline_col : source_color; //Outline color

void fragment() {
	vec4 col = texture(TEXTURE,UV);
	
	//Get alpha val of adjacent pixels
	vec2 p = TEXTURE_PIXEL_SIZE;
	float a = texture(TEXTURE,UV+vec2(p.x,0)).a;
	a += texture(TEXTURE,UV+vec2(-p.x,0)).a;
	a += texture(TEXTURE,UV+vec2(0,p.y)).a;
	a += texture(TEXTURE,UV+vec2(0,-p.y)).a;
	a = step(a,.5); //Clamp the a value using found alpha value
	
	col.rgb = mix(outline_col.xyz, col.rgb, col.a);
	col.a = step(a, col.a);
	
	COLOR = col; //Get palette color
}