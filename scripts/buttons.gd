extends VBoxContainer


# Don't show exit button in web version because browsers manage tabs themselves
func _ready():
	if OS.has_feature("web"):
		$Exit.visible = false
