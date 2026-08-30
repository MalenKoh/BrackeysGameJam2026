shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, repeat_disable, filter_nearest;
uniform float crt_curve: hint_range(0.0, 1.0);
uniform float scanline_count: hint_range(0.0, 20.0);
uniform float scanline_size: hint_range(0, 10);
uniform float scanline_intensity: hint_range(0, 1);
uniform float crt_brightness: hint_range(0.0, 1.0);
uniform float crt_ghost: hint_range(0.0, 10.0);
uniform float crt_white_noise: hint_range(0.0, 1.0);
uniform float crt_grid: hint_range(0.0, 1.0);
uniform float vignette_multiplier: hint_range(0.0, 1.0);

float random(vec2 uv) {
	return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
	// Called for every pixel the material is visible on.
	float time = TIME;
	
	// Screen curve
	vec2 crt_curve_shift = (vec2(1.0) - sin(UV.yx * PI)) * crt_curve;
	vec2 crt_curve_scale = vec2(1.0) + crt_curve_shift * 2.0;
	vec2 screen_uv = SCREEN_UV * crt_curve_scale - crt_curve_shift;
	vec2 uv = UV * crt_curve_scale - crt_curve_shift;
	float crt_mask = float(uv.x >= 0.0 && uv.x <= 1.0 && uv.y >= 0.0 && uv.y <= 1.0);
	
	// Scanlines
	float scanlines = mod(float(FRAGCOORD.y), scanline_count);
	scanlines = 1.0 - (step(scanline_size, scanlines));
	scanlines *= scanline_intensity;
	
	//  Pixel blurring
	vec3 colour = texture(SCREEN_TEXTURE, screen_uv).rgb * (1.0 - crt_brightness * 0.5);
	colour.rgb *= 1.0 - scanlines;
	colour += texture(SCREEN_TEXTURE, screen_uv - vec2(SCREEN_PIXEL_SIZE.x * crt_ghost, 0.0)).rgb;
	colour += texture(SCREEN_TEXTURE, screen_uv + vec2(SCREEN_PIXEL_SIZE.x * crt_ghost, 0.0)).rgb;
	colour *= crt_brightness * 0.25 * crt_mask;
	
	// Static
	vec2 noise_pixel = vec2(floor((screen_uv.x / SCREEN_PIXEL_SIZE.x) / 3.0) * 3.0, screen_uv.y) - sin(UV.yx * PI);
	float white_noise = random(noise_pixel + vec2(sin(time * PI / 4.0), cos(time * PI / 8.0))) * crt_mask;
	colour = mix(colour, vec3(white_noise), crt_white_noise);
	
	// RGB split
	float crt_grid_uv = mod(SCREEN_UV.x / SCREEN_PIXEL_SIZE.x, 3.0);
	vec3 crt_grid_colour;
	crt_grid_colour.r = clamp(1.0 - crt_grid_uv, 0.0, 1.0) + clamp(crt_grid_uv - 2.0, 0.0, 1.0);
	crt_grid_colour.g = clamp(1.0 - abs(1.0 - crt_grid_uv), 0.0, 1.0);
	crt_grid_colour.b = 1.0 - crt_grid_colour.r - crt_grid_colour.g;
	colour *= clamp(normalize(clamp(crt_grid_colour, crt_grid, 1.0)), vec3(0.0), vec3(1.0));
	
	// Vignette
	vec3 vignette = vec3(length(pow(abs(SCREEN_UV * 2.0 - 1.0), vec2(4.0)) / 3.0));
	colour -= vignette * vignette_multiplier;
	COLOR = vec4(colour, 1.0);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
