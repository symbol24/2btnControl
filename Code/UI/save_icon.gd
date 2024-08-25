class_name SaveIcon extends TBControl

@onready var animator: AnimationPlayer = %animator


func _toggle_display(_id := "", _visible := true) -> void:
	if _id == id:
		set_deferred("visible", _visible)
		if _visible:
			if !animator.is_playing(): animator.play("key")
		else:
			if animator.is_playing(): 
				animator.stop()
				animator.play("RESET")
