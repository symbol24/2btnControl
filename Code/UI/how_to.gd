class_name HowTo extends TBControl


@onready var btn_back: Button = %btn_back


func _ready() -> void:
	btn_back.pressed.connect(_btn_back_pressed)
	
	
func _btn_back_pressed() -> void:
	hide()
	S.ToggleDisplay.emit(Ui.previous, true)
