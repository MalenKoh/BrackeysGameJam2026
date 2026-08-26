shader_type canvas_item;
render_mode unshaded, skip_vertex_transform;

uniform sampler2D base_screen: hint_screen_texture, filter_linear_mipmap;

uniform float screen_height;
const float screen_curvature = 3.0;
const float scanline_intensity_multipler = 0.1;
const float scanline_intensity_addend = 0.8;
const float vignette_multiplier = 0.75;
const float pixel_bleed = 0.5;

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 centred_uv = SCREEN_UV * 2.0 - 1.0;
	vec2 uv_offset = centred_uv.yx / screen_curvature;
	vec2 warped_uv = centred_uv * (pow(uv_offset, vec2(2.0)) + 1.0);
	vec2 uncentred_warped_uv = (warped_uv + 1.0) / 2.0;
	
	vec3 cutoff = vec3(step(abs(warped_uv.x), 1.0) * step(abs(warped_uv.y), 1.0));
	vec3 scanlines = vec3(sin(warped_uv.y * 2.0 * screen_height / 5.0) * scanline_intensity_multipler + scanline_intensity_addend);
	vec3 vignette = vec3(length(pow(abs(centred_uv), vec2(4.0)) / 3.0));
	vec3 screen_colour = textureLod(base_screen, uncentred_warped_uv, pixel_bleed).rgb * cutoff * scanlines;
	screen_colour -= vignette * vignette_multiplier;
	
	COLOR = vec4(screen_colour, 1.0);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
