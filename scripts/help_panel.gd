extends CanvasLayer


func _ready():
	visible = false  # start hidden
	Game.mode_changed.connect(_on_mode_changed)

func _on_mode_changed(mode):
	visible = (mode != Game.Mode.MENU)
