class_name MainMenu extends Node2D

const MUSIC = preload("res://Data/Audio/music.tres")

func _ready() -> void:
	S.PlayAudio.emit(MUSIC)
