class_name LevelButton extends TBButton

var level_id := ""

func _ready() -> void:
	super()
	pressed.connect(_button_pressed)

func _button_pressed():
	S.ToggleDisplay.emit("level_selector", false)
	S.LoadScene.emit(level_id)
