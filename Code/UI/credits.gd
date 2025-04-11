class_name Credits extends TBControl


@onready var btn_close: Button = %btn_close


func _ready() -> void:
	btn_close.pressed.connect(_btn_close_pressed)


func _btn_close_pressed() -> void:
	hide()
	S.ToggleDisplay.emit(Ui.previous, true)


func toggle_display(_visible := true) -> void:
	visible = _visible
	btn_close.grab_focus()
