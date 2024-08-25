class_name LevelSelector extends TBControl

const LEVEL_BUTTON = preload("res://Scenes/UI/level_button.tscn")
const LEVEL_PAGE = preload("res://Scenes/UI/level_page.tscn")

@onready var back: Button = %back
@onready var tab_container: TabContainer = %TabContainer

@export var buttons_per_page := 45

var button_pool := []

func _ready() -> void:
	super()
	back.pressed.connect(_back_pressed)
	_construct_level_pages(GM.LEVELS.level_order)

func _back_pressed() -> void:
	hide()

func _construct_level_pages(_level_name:Array[String]) -> void:
	if !_level_name.is_empty():
		var page_count = ceil(_level_name.size() / buttons_per_page) if _level_name.size() > 45 else 1
		#print("constructing ", page_count, " level pages")
		for x in page_count:
			var new_page = LEVEL_PAGE.instantiate()
			new_page.name = "Page "+str(x+1)
			var i = x * buttons_per_page
			while i < (x+1) * buttons_per_page and i < _level_name.size():
				var new_button = LEVEL_BUTTON.instantiate()
				new_button.name = "level_"+str(i)
				new_button.level_id = _level_name[i]
				new_button.text = str(i+1)
				button_pool.append(new_button)
				new_page.add_child.call_deferred(new_button)
				i += 1
			tab_container.add_child.call_deferred(new_page)

func _toggle_display(_id = "", _visible := true) -> void:
	if _id == id:
		set_deferred("visible", _visible)
		if !button_pool.is_empty() and _visible:
			button_pool[0].grab_focus()
