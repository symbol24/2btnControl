class_name LevelSelector extends TBControl


const LEVEL_BUTTON = preload("res://Scenes/UI/level_button.tscn")
const LEVEL_PAGE = preload("res://Scenes/UI/level_page.tscn")


@export var buttons_per_page := 45

@onready var back: Button = %back
@onready var tab_container: TabContainer = %TabContainer

var button_pool := []


func _ready() -> void:
	back.pressed.connect(_back_pressed)
	_construct_level_pages(GM.LEVELS.levels)


func _back_pressed() -> void:
	if GM.active_level != null and GM.active_level.is_in_group(&"level"):
		hide()
		S.ResetLevel.emit()
		S.PauseGame.emit(false)
	else:
		hide()
		S.ToggleDisplay.emit(Ui.previous, true)


func _construct_level_pages(levels:Dictionary) -> void:
	if !levels.is_empty():
		var keys:Array = levels.keys()
		var page_count = ceil(keys.size() / buttons_per_page) if keys.size() > 45 else 1
		#print("constructing ", page_count, " level pages")
		for x in page_count:
			var new_page := LEVEL_PAGE.instantiate()
			new_page.name = "Page "+str(x+1)
			var i = x * buttons_per_page
			while i < (x+1) * buttons_per_page and i < keys.size():
				var new_button := LEVEL_BUTTON.instantiate()
				new_button.name = "level_"+str(i)
				new_button.level_id = keys[i]
				new_button.text = str(keys[i])
				button_pool.append(new_button)
				new_page.add_child.call_deferred(new_button)
				i += 1
			tab_container.add_child.call_deferred(new_page)


func toggle_display(_visible := true) -> void:
	visible = _visible
	if _visible:
		if not button_pool.is_empty() and _visible:
			button_pool[0].grab_focus.call_deferred()
