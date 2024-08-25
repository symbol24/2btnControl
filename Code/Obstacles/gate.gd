class_name Gate extends StaticBody2D

@onready var closed: TileMapLayer = %closed
@onready var open: TileMapLayer = %open
@onready var collider: CollisionPolygon2D = %collider

func _ready() -> void:
	S.ToggleGate.connect(_toggle_gate)

func _toggle_gate(_value:=true) -> void:
	if _value:
		open.show()
		closed.hide()
		collider.set_deferred("disabled", true)
	else:
		closed.show()
		open.hide()
		collider.set_deferred("disabled", false)
		
