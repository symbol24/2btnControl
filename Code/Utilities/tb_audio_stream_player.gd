class_name TBAudioStreamPlayer extends AudioStreamPlayer

func _ready():
	tree_exiting.connect(_exiting_tree)
	
func _exiting_tree():
	S.AudioExiting.emit(self)
