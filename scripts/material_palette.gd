extends Node

signal palette_changed(new_id: int)

var colors: Dictionary = {
	0: Color(0.000, 0.000, 0.016),
	1: Color(0.259, 0.039, 0.408),
	2: Color(0.576, 0.149, 0.404),
	3: Color(0.867, 0.318, 0.227),
	4: Color(0.988, 0.647, 0.039),
	5: Color(0.988, 1.000, 0.643),
}

var _next_id: int = 6

func get_color(id: int) -> Color:
	return colors.get(id, Color.MAGENTA)

func create_color(color: Color) -> int:
	var id := _next_id
	_next_id += 1

	colors[id] = color
	palette_changed.emit(id)
	return id
	
func get_all() -> Dictionary:
	return colors.duplicate()
