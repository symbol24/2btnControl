class_name MainMenu extends TBControl

@onready var play: Button = %Play
@onready var level_select: Button = %level_select

func _ready() -> void:
	super()
	play.pressed.connect(_pressed_play)
	level_select.pressed.connect(_pressed_levels)
	

func _pressed_play() -> void:
	S.LoadScene.emit("level_001")

func _pressed_levels() -> void:
	S.ToggleDisplay.emit("level_selector", true)
