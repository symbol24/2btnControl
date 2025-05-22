extends CanvasLayer


const MAINMENU:String = "uid://duk7v5lrmx0hk"
const LOADINGSCREEN:String = "uid://ew1yf4g5scj6"
const LEVELSELECTOR:String = "uid://dfbftahbhub4r"
const PAUSEMENU:String = "uid://babunivobt1ed"
const RESULTSCREEN:String = "uid://bac7cgigqb4ep"
const GAMEPLAYUI:String = "uid://hyyhf40kqab8"
const HOWTO:String = "uid://dy4fgwyyqrdnm"
const SETTINGS:String = "uid://bn767iuoh3wj4"
const CREDITS:String = "uid://dkyy7qajjbty2"


@onready var uis:Array[TBControl] = []

var previous:StringName = &""
var current:StringName = &""
var ls_displayed:bool = false
var active_screen:StringName = &""


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"pause"):
		if previous != &"" and not active_screen in [&"loading_screen", &"result_screen"]:
			S.ToggleDisplay.emit(current, false, previous)
			S.ToggleDisplay.emit(previous, true)
		else:
			if not GM.is_loading and GM.active_level != null and GM.active_level.is_in_group(&"main_menu") and previous == &"":
				S.ToggleDisplay.emit(&"main_menu", GM.is_playing)
			elif not GM.is_loading and GM.active_level != null and GM.active_level.is_in_group(&"level") and previous == &"":
				S.ToggleDisplay.emit(&"pause_menu", GM.is_playing)
			_toggle_mouse()


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	S.ToggleDisplay.connect(_toggle_ui)
	S.HideMouse.connect(_toggle_mouse)
	_toggle_mouse()


func _toggle_ui(id:StringName, _visible:bool = false, _from:StringName = &"") -> void:
	previous = _from
	current = id
	var tbcontrol:TBControl = _get_tbcontrol(id)
	if not tbcontrol.is_node_ready(): await tbcontrol.ready
	if tbcontrol: tbcontrol.toggle_display(_visible)


func _get_tbcontrol(id:StringName) -> TBControl:
	for each in uis:
		if each.id == id:
			return each
	
	var to_load:PackedScene = null
	match id:
		&"main_menu":
			to_load = load(MAINMENU)
		&"gameplay_ui":
			to_load = load(GAMEPLAYUI)
		&"level_selector":
			to_load = load(LEVELSELECTOR)
		&"loading_screen":
			to_load = load(LOADINGSCREEN)
		&"pause_menu":
			to_load = load(PAUSEMENU)
		&"result_screen":
			to_load = load(RESULTSCREEN)
		&"howto":
			to_load = load(HOWTO)
		&"settings":
			to_load = load(SETTINGS)
		&"credits":
			to_load = load(CREDITS)
		_:
			pass
	if to_load != null:
		var tbcontrol:TBControl = to_load.instantiate()
		add_child(tbcontrol)
		uis.append(tbcontrol)
		return tbcontrol
		
	return null
	

func _toggle_mouse() -> void:
	#if not OS.has_feature("editor"): Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED || Input.mouse_mode == Input.MOUSE_MODE_HIDDEN:
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			if not OS.has_feature("editor"): Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
		else:
			if not OS.has_feature("editor"): Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			if not OS.has_feature("editor"): Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			if not OS.has_feature("editor"): Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
