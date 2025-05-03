class_name LevelButton extends TBButton


@onready var star: TextureRect = %star

var level_id:int = -1


func _ready() -> void:
	pressed.connect(_button_pressed)


func toggle_star(id:int) -> void:
	var color:Color = GM.BRONZE
	match id:
		2:
			color = GM.SILVER
		3: 
			color = GM.GOLD
		_:
			pass
	star.modulate = color
	
	if id > 0: star.show()
	else: star.hide()


func _button_pressed() -> void:
	S.ToggleDisplay.emit(&"level_selector", false)
	S.HideMouse.emit()
	S.LoadScene.emit(level_id)
