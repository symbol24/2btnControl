class_name TBControl extends Control

@export var id := ""

func _ready() -> void:
	S.ToggleDisplay.connect(_toggle_display)

func _toggle_display(_id = "", _visible := true) -> void:
	if _id == id:
		print("Making ", _id, " visible: ", _visible)
		set_deferred("visible", _visible)
