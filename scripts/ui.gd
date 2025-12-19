extends CanvasLayer

func _ready():
	visible = false
	Game.mode_changed.connect(_on_mode_changed)

func _on_mode_changed(mode):
	visible = (mode == Game.Mode.MATERIAL_PICKER)


func _on_color_picker_focus_exited() -> void:
	if Game.mode == Game.Mode.MATERIAL_PICKER:
		Game.set_mode(Game.Mode.GAMEPLAY)
	visible = false
