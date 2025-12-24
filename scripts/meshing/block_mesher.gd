class_name BlockMesher
extends VoxelMesher

# ─────────────────────────────────────────────────────────────────────────────
# Face definitions
# ─────────────────────────────────────────────────────────────────────────────

const FACE_DIRS := [
	Vector3i( 1,  0,  0), # +X
	Vector3i(-1,  0,  0), # -X
	Vector3i( 0,  1,  0), # +Y
	Vector3i( 0, -1,  0), # -Y
	Vector3i( 0,  0,  1), # +Z
	Vector3i( 0,  0, -1)  # -Z
]

const FACE_NORMALS := [
	Vector3( 1,  0,  0),
	Vector3(-1,  0,  0),
	Vector3( 0,  1,  0),
	Vector3( 0, -1,  0),
	Vector3( 0,  0,  1),
	Vector3( 0,  0, -1)
]

# Each face is defined in counter-clockwise order
const FACE_VERTS := [
	# +X
	[Vector3(1,0,0), Vector3(1,1,0), Vector3(1,1,1), Vector3(1,0,1)],
	# -X
	[Vector3(0,0,1), Vector3(0,1,1), Vector3(0,1,0), Vector3(0,0,0)],
	# +Y
	[Vector3(0,1,1), Vector3(1,1,1), Vector3(1,1,0), Vector3(0,1,0)],
	# -Y
	[Vector3(0,0,0), Vector3(1,0,0), Vector3(1,0,1), Vector3(0,0,1)],
	# +Z
	[Vector3(1,0,1), Vector3(1,1,1), Vector3(0,1,1), Vector3(0,0,1)],
	# -Z
	[Vector3(0,0,0), Vector3(0,1,0), Vector3(1,1,0), Vector3(1,0,0)]
]

# ─────────────────────────────────────────────────────────────────────────────
# Entry point
# ─────────────────────────────────────────────────────────────────────────────

func generate(chunk, vertices, normals, colors):
	for x in range(chunk.SIZE_X):
		for y in range(chunk.SIZE_Y):
			for z in range(chunk.SIZE_Z):
				_emit_block(chunk, Vector3i(x, y, z), vertices, normals, colors)

# ─────────────────────────────────────────────────────────────────────────────
# Block emission
# ─────────────────────────────────────────────────────────────────────────────

func _emit_block(chunk, p: Vector3i, vertices, normals, colors):
	# Air → nothing to emit
	if chunk.get_density(p) > chunk.ISO_LEVEL:
		return

	var material_id = chunk.get_material(p)
	var color = chunk.material_id_to_color(material_id)

	for face in range(6):
		var np = p + FACE_DIRS[face]

		# Neighbor solid → face hidden
		if chunk.get_density(np) <= chunk.ISO_LEVEL:
			continue

		_emit_face(
			Vector3(p),
			FACE_VERTS[face],
			FACE_NORMALS[face],
			color,
			vertices,
			normals,
			colors
		)

# ─────────────────────────────────────────────────────────────────────────────
# Quad → two triangles
# ─────────────────────────────────────────────────────────────────────────────

func _emit_face(
	base: Vector3,
	verts: Array,
	normal: Vector3,
	color: Color,
	vertices,
	normals,
	colors
):
	var a = base + verts[0]
	var b = base + verts[1]
	var c = base + verts[2]
	var d = base + verts[3]

	# Triangle 1
	vertices.append(a)
	vertices.append(c)
	vertices.append(b)

	# Triangle 2
	vertices.append(a)
	vertices.append(d)
	vertices.append(c)

	for i in range(6):
		normals.append(normal)
		colors.append(color)
