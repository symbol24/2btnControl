class_name Gate extends StaticBody2D

const GATE_CLOSED = preload("res://Data/Audio/gate_closed.tres")
const GATE_OPEN = preload("res://Data/Audio/gate_open.tres")

@onready var closed: TileMapLayer = %closed
@onready var open: TileMapLayer = %open
@onready var collider: CollisionPolygon2D = %collider

var is_open := false

func _ready() -> void:
	S.ToggleGate.connect(_toggle_gate)

func _toggle_gate() -> void:
	if !open.is_visible():
		open.show()
		closed.hide()
		collider.set_deferred("disabled", true)
		S.PlayAudio.emit(GATE_OPEN)
	elif open.is_visible():
		closed.show()
		open.hide()
		collider.set_deferred("disabled", false)
		S.PlayAudio.emit(GATE_CLOSED)
		
