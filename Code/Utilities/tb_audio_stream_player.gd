class_name TBAudioStreamPlayer extends AudioStreamPlayer

func _ready() -> void:
	tree_exiting.connect(_exiting_tree)
	
func _exiting_tree() -> void:
	S.AudioExiting.emit(self)
