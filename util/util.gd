
static func get_sphere_volume(r: float) -> float:
	return PI * r * r * r * 4.0 / 3.0


static func find_node_by_type(parent, klass):
	for i in parent.get_child_count():
		var child = parent.get_child(i)
		if child is klass:
			return child
		var res = find_node_by_type(child, klass)
		if res != null:
			return res
	return null


static func format_integer_with_commas(n: int) -> String:
	if n < 0:
		return "-" + format_integer_with_commas(-n)
	if n < 1000:
		return str(n)
	if n < 1000000:
		return str(n / 1000, ",", n % 1000)
	if n < 10000000000:
		return str(n / 1000000, ",", (n / 1000) % 10000000, ",", n % 1000)
	push_error("Number too big for shitty function")
	assert(false)
	return "<error>"


static func ray_intersects_sphere(
	ray_origin: Vector3, ray_dir: Vector3, center: Vector3, radius: float) -> bool:
	
	var t = (center - ray_origin).dot(ray_dir)
	if t < 0.0:
		return false
	var p = ray_origin + ray_dir * t
	var y = (center - p).length()
	return y <= radius


# CubeMesh doesn't have a wireframe option
static func create_wirecube_mesh(color = Color(1,1,1)) -> Mesh:
	var positions := PoolVector3Array([
		Vector3(0, 0, 0),
		Vector3(1, 0, 0),
		Vector3(1, 0, 1),
		Vector3(0, 0, 1),
		Vector3(0, 1, 0),
		Vector3(1, 1, 0),
		Vector3(1, 1, 1),
		Vector3(0, 1, 1),
	])
	var colors := PoolColorArray([
		color, color, color, color,
		color, color, color, color,
	])
	var indices := PoolIntArray([
		0, 1,
		1, 2,
		2, 3,
		3, 0,

		4, 5,
		5, 6,
		6, 7,
		7, 4,

		0, 4,
		1, 5,
		2, 6,
		3, 7
	])
	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = positions
	arrays[Mesh.ARRAY_COLOR] = colors
	arrays[Mesh.ARRAY_INDEX] = indices
	var mesh := ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, arrays)
	return mesh

