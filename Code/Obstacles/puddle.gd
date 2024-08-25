class_name Puddle extends Area2D

func _ready() -> void:
	body_entered.connect(_body_entered)
	body_exited.connect(_body_exited)
	
func _body_entered(_body) -> void:
	if _body is PlayerCar:
		_body.set_deferred("in_puddle", true)
		
func _body_exited(_body) -> void:
	if _body is PlayerCar:
		_body.set_deferred("in_puddle", false)
