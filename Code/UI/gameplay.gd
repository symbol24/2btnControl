class_name GameplayUI extends TBControl

@onready var level_timer: RichTextLabel = %level_timer

func _ready() -> void:
	super()
	S.UpdateLevelTimer.connect(_update_timer)

func _update_timer(_value := "") -> void:
	level_timer.text = _value
