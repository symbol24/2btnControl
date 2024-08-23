class_name MainMenu extends TBControl

@onready var play: Button = %Play

func _ready() -> void:
	super()
	play.pressed.connect(_pressed_play)
	

func _pressed_play():
	S.LoadScene.emit("level_001")
