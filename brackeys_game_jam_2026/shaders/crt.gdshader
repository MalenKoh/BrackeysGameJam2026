/*shader_type canvas_item;
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
}*/

shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, repeat_disable, filter_nearest;
uniform float crt_brightness: hint_range(0.0, 1.0) = 1.0;
uniform float crt_ghost: hint_range(0.0, 10.0) = 3.0;
uniform float crt_grid: hint_range(0.0, 1.0) = 0.4;
uniform float crt_white_noise: hint_range(0.0, 1.0) = 0.0;
uniform float crt_curve: hint_range(0.0, 1.0) = 0.05;

float random(vec2 uv) {
	return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
	// Called for every pixel the material is visible on.
	float time = TIME;
	
	// CRT curve
	vec2 crt_curve_shift = (vec2(1.0) - sin(UV.yx * PI)) * crt_curve;
	vec2 crt_curve_scale = vec2(1.0) + crt_curve_shift * 2.0;
	vec2 screen_uv = SCREEN_UV * crt_curve_scale - crt_curve_shift;
	vec2 uv = UV * crt_curve_scale - crt_curve_shift;
	float crt_mask = float(uv.x >= 0.0 && uv.x <= 1.0 && uv.y >= 0.0 && uv.y <= 1.0);
	
	//  CRT ghost
	vec3 colour = texture(SCREEN_TEXTURE, screen_uv).rgb * (1.0 - crt_brightness * 0.5);
	colour += texture(SCREEN_TEXTURE, screen_uv - vec2(SCREEN_PIXEL_SIZE.x * crt_ghost, 0.0)).rgb;
	colour += texture(SCREEN_TEXTURE, screen_uv + vec2(SCREEN_PIXEL_SIZE.x * crt_ghost, 0.0)).rgb;
	colour *= crt_brightness * 0.25 * crt_mask;
	
	// CRT noise
	vec2 noise_pixel = vec2(floor((screen_uv.x / SCREEN_PIXEL_SIZE.x) / 3.0) * 3.0, screen_uv.y) - sin(UV.yx * PI);
	float white_noise = random(noise_pixel + vec2(sin(time * PI / 4.0), cos(time * PI / 8.0))) * crt_mask;
	colour = mix(colour, vec3(white_noise), crt_white_noise);
	
	// CRT RGB split
	float crt_grid_uv = mod(SCREEN_UV.x / SCREEN_PIXEL_SIZE.x, 3.0);
	vec3 crt_grid_colour;
	crt_grid_colour.r = clamp(1.0 - crt_grid_uv, 0.0, 1.0) + clamp(crt_grid_uv - 2.0, 0.0, 1.0);
	crt_grid_colour.g = clamp(1.0 - abs(1.0 - crt_grid_uv), 0.0, 1.0);
	crt_grid_colour.b = 1.0 - crt_grid_colour.r - crt_grid_colour.g;
	colour *= clamp(normalize(clamp(crt_grid_colour, crt_grid, 1.0)), vec3(0.0), vec3(1.0));
	
	COLOR = vec4(colour, 1.0);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
