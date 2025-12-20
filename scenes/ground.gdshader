shader_type spatial;
render_mode cull_back, depth_draw_opaque;

uniform float chunk_size = 16.0;
uniform float cell_size  = 1.0;

uniform float chunk_line_width = 0.12;
uniform float cell_line_width  = 0.03;

uniform vec3 chunk_color : source_color = vec3(1.0, 0.0, 0.0);
uniform vec3 cell_color  : source_color = vec3(0.0, 0.8, 1.0);

varying vec3 world_pos;

float grid_line(float coord, float size, float width) {
	float g = abs(mod(coord, size));
	float d = min(g, size - g);
	return 1.0 - smoothstep(0.0, width, d);
}

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	// Chunk grid
	float chunk_x = grid_line(world_pos.x, chunk_size, chunk_line_width);
	float chunk_z = grid_line(world_pos.z, chunk_size, chunk_line_width);
	float chunk_grid = max(chunk_x, chunk_z);

	// Density / cell grid
	float cell_x = grid_line(world_pos.x, cell_size, cell_line_width);
	float cell_z = grid_line(world_pos.z, cell_size, cell_line_width);
	float cell_grid = max(cell_x, cell_z);

	vec3 color = ALBEDO;
	color = mix(color, cell_color,  cell_grid * 0.5);
	color = mix(color, chunk_color, chunk_grid);

	ALBEDO = color;
}
