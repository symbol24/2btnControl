class_name LevelButton extends Button

var level_id := ""

func _ready() -> void:
	pressed.connect(_button_pressed)

func _button_pressed():
	S.ToggleDisplay.emit("level_selector", false)
	S.LoadScene.emit(level_id)
