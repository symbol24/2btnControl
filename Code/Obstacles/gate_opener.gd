class_name GateOpener extends Area2D

@export var must_hold := false

func _ready() -> void:
	body_entered.connect(_body_entered)
	body_exited.connect(_body_exited)

func _body_entered(_body) -> void:
	if _body is PlayerCar:
		print("sending open gate")
		S.ToggleGate.emit(true)
		
func _body_exited(_body) -> void:
	if _body is PlayerCar:
		if must_hold: S.ToggleGate.emit(false)
