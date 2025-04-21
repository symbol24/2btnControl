class_name LevelSelector extends TBControl


const LEVEL_BUTTON = preload("res://Scenes/UI/level_button.tscn")


@export var buttons_per_page := 45


@onready var normal: GridContainer = %normal
@onready var compact: GridContainer = %compact
@onready var suv: GridContainer = %suv
@onready var limo: GridContainer = %limo
@onready var bus: GridContainer = %bus
@onready var monster_truck: GridContainer = %monster_truck
@onready var back: Button = %back

var button_pool:Array[LevelButton]  = []


func _ready() -> void:
	back.pressed.connect(_back_pressed)
	await _construct_level_pages(GM.LEVELS.levels)


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
		#print("constructing ", page_count, " level pages")
		for x in keys:
			var new_button := LEVEL_BUTTON.instantiate()
			new_button.name = "level_"+str(x)
			new_button.level_id = x
			new_button.text = str(x)
			_get_to_child_to(levels[x].car).add_child.call_deferred(new_button)
			if not new_button.is_node_ready(): await new_button.ready
			if PD.data.levels.has(x): new_button.toggle_star(PD.data.levels[x][&"stars"])
			else: new_button.toggle_star(0)
			button_pool.append(new_button)
		button_pool[0].grab_focus.call_deferred()


func toggle_display(_visible := true) -> void:
	visible = _visible
	if _visible:
		if not button_pool.is_empty() and _visible:
			_update_stars()
			button_pool[0].grab_focus.call_deferred()


func _update_stars() -> void:
	for button in button_pool:
		if PD.data.levels.has(button.level_id):
			button.toggle_star(PD.data.levels[button.level_id][&"stars"])


func _get_to_child_to(type:GM.Vehicle_Type) -> GridContainer:
	match type:
		GM.Vehicle_Type.COMPACT:
			return compact
		GM.Vehicle_Type.SUV:
			return suv
		GM.Vehicle_Type.LIMO:
			return limo
		GM.Vehicle_Type.BUS:
			return bus
		GM.Vehicle_Type.MONSTERTRUCK:
			return monster_truck
		_:
			return normal
