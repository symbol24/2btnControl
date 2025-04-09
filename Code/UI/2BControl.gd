class_name TBControl extends Control

@export var id := &""

var previous:StringName = &""


func toggle_display(_visible := true) -> void:
	visible = _visible
