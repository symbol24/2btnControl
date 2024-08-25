class_name LoadingScreen extends TBControl

@onready var loading_text: RichTextLabel = %loading_text

var char_count := 0
var current := 0
var timer := 0.0:
	set(_value):
		timer = _value
		if timer >= show_delay:
			timer = 0.0
			char_update = true
var show_delay := 0.2
var char_update := false

func _ready() -> void:
	super()
	char_count = loading_text.get_total_character_count()
	loading_text.set_visible_characters(0)

func _physics_process(_delta: float) -> void:
	if visible:
		timer += _delta
		if char_update:
			char_update = false
			current = _show_next_char(current, char_count)

func _show_next_char(_current := 0, _max := 1) -> int:
	_current += 1
	if _current > _max: _current = 0
	loading_text.set_visible_characters(_current)
	return _current
