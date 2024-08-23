extends Node

const LEVELS = preload("res://Data/levels.tres")

var active_level
var game:Game
var is_loading := false
var to_load := ""
var load_complete := false
var loading_status := 0.0
var progress := []
var extra_loading := false
var loading_delay := 5.0

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	S.LoadScene.connect(_load_scene)
	S.LoadSceneFromPath.connect(_load_from_path)
	S.GameReady.connect(_set_game)
	S.CarParked.connect(_car_parked)

func _physics_process(_delta: float) -> void:
	if is_loading:
		loading_status = ResourceLoader.load_threaded_get_status(to_load, progress)
		print("loading ", to_load , ": ", progress[0]*100, "%")
		if loading_status == ResourceLoader.THREAD_LOAD_LOADED:
			if !load_complete:
				load_complete = true
				_complete_load()

func _load_from_path(_path := "") -> void:
	print("Received load from path signal: ", _path)
	if _path:
		var loaded = load(_path)
		get_tree().change_scene_to_packed.call_deferred(loaded)

func _load_scene(_id := "") -> void:
	print("received load scene signal for id: ", _id)
	S.ToggleDisplay.emit("loading_screen", true)
	var path = LEVELS.get_level(_id)
	if path == "": 
		push_error("Level list does not contain ", _id)
		S.ToggleDisplay.emit("loading_screen", false)
		return
	
	if active_level != null: 
		game.remove_child.call_deferred(active_level)
		active_level.queue_free.call_deferred()
		
	to_load = path
	is_loading = true
	load_complete = false
	ResourceLoader.load_threaded_request(to_load)

func _complete_load() -> void:
	is_loading = false
	var new_world = ResourceLoader.load_threaded_get(to_load)
	
	game.add_child.call_deferred(new_world.instantiate())
	await get_tree().create_timer(loading_delay).timeout
	S.ToggleDisplay.emit("loading_screen", false)

func _set_game(_game:Game) -> void:
	if _game != null:
		game = _game
		S.LoadScene.emit("main_menu")

func _car_parked():
	await get_tree().create_timer(1).timeout
	
	S.ToggleDisplay.emit("result_screen", true)
