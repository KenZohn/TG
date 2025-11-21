shader_type canvas_item;

uniform float lod : hint_range(0.0, 5.0) = 2.0;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV, lod);
	vec4 overlay = vec4(0.0, 0.0, 0.0, 0.85);
	color = mix(color, overlay, overlay.a);
	COLOR = vec4(color.rgb, 1.0);
}
