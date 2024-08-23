class_name Boot extends Node2D

const GAME = "res://Scenes/Utilities/game.tscn"

func _ready() -> void:
	S.LoadSceneFromPath.emit(GAME)
