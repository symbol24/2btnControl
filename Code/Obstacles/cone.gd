class_name Cone extends Area2D

@onready var collider: CollisionShape2D = %collider
@onready var up: TileMapLayer = %up
@onready var down: TileMapLayer = %down

func _ready() -> void:
	body_entered.connect(_body_entered)
	
func _body_entered(_body) -> void:
	if _body is PlayerCar:
		up.hide()
		down.show()
		collider.set_deferred("disabled", true)
		S.ConeHit.emit()
