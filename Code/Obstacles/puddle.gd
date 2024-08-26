class_name Puddle extends Area2D

const PUDDLE = preload("res://Data/Audio/puddle.tres")

func _ready() -> void:
	body_entered.connect(_body_entered)
	body_exited.connect(_body_exited)
	
func _body_entered(_body) -> void:
	if _body is PlayerCar:
		_body.set_deferred("in_puddle", true)
		S.PlayAudio.emit(PUDDLE)
		
func _body_exited(_body) -> void:
	if _body is PlayerCar:
		_body.set_deferred("in_puddle", false)
		S.PlayAudio.emit(PUDDLE)
