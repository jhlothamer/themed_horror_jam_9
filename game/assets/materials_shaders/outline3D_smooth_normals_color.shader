shader_type spatial;
render_mode unshaded, cull_front, depth_draw_always;

uniform float thickness = 0.1;
uniform vec4 outline_color : hint_color = vec4(1.0);
uniform bool enabled = false;

void vertex() {
	if(enabled) {
		vec3 normal = (COLOR.xyz - vec3(0.5)) * 1.5;
		VERTEX += (normal * thickness);
	}
}

void fragment() {
	if(enabled) {
		ALBEDO = outline_color.rgb;
		ALPHA = outline_color.a;
	}
}