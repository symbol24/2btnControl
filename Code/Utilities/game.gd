class_name Game extends Node2D

func _ready() -> void:
	S.GameReady.emit(self)
