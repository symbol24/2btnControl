class_name SaveIcon extends TBControl


@export var cycles:int = 3
@export var tween_time:float = 1.0

@onready var icon: TextureRect = %icon


func _ready() -> void:
	S.DisplaySaveIcon.connect(_display_save)


func _display_save() -> void:
	var cycle:int = 0
	while cycle < cycles:
		var tween:Tween = create_tween()
		tween.set_parallel(false)
		tween.tween_property(icon, "modulate", Color.WHITE, tween_time)
		tween.tween_property(icon, "modulate", Color.TRANSPARENT, tween_time)
		await tween.finished
		cycle += 1
