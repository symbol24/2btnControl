class_name Hut extends StaticBody2D

@export var level_number := ""

@onready var level_id: RichTextLabel = %level_id

func _ready() -> void:
	level_id.text = level_number
