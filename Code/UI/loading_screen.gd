class_name LoadingScreen extends TBControl

@onready var loading_text: RichTextLabel = %loading_text

var timer := 0.0:
	set(_value):
		timer = _value
		if timer >= delay:
			timer = 0.0
			_move_text(loading_text)
var delay := 2.0

func _ready() -> void:
	super()

func _physics_process(_delta: float) -> void:
	if is_visible():
		timer += _delta

func _move_text(_text:RichTextLabel):
	if _text:
		var x = randf_range(75, 170)
		var y = randf_range(25, 130)
		_text.global_position = Vector2(x,y)
