shader_type spatial;
render_mode cull_disabled, depth_draw_opaque;

uniform sampler2D grass_texture : filter_nearest, source_color;

void vertex(){
	NORMAL = vec3(0.0, 1.0, 0.0);
	VERTEX.x += sin(NODE_POSITION_WORLD.x + TIME * 0.25 + UV.y) * ( 1.0 - UV.y) * 0.1
	;
	;
}

void fragment(){
	ALBEDO = texture(grass_texture, UV).rgb;
	ALPHA = texture(grass_texture, UV).a;
}
