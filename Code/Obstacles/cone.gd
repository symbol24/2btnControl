class_name Cone extends Area2D

const CONE_SQUISH = preload("res://Data/Audio/cone_squish.tres")

@onready var collider: CollisionShape2D = %collider
@onready var up: TileMapLayer = %up
@onready var down: TileMapLayer = %down

var squished := false

func _ready() -> void:
	body_entered.connect(_body_entered)
	
func _body_entered(_body) -> void:
	if _body is PlayerCar and !squished:
		up.hide()
		down.show()
		collider.set_deferred("disabled", true)
		S.ConeHit.emit()
		S.PlayAudio.emit(CONE_SQUISH)
		squished = true
