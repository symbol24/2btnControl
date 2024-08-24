extends Node

const LEVELS = preload("res://Data/levels.tres")

var is_playing:bool:
	get:
		return !get_tree().paused

#Levels and loading
var active_level
var game:Game
var is_loading := false
var to_load := ""
var load_complete := false
var loading_status := 0.0
var progress := []
var extra_loading := false
var loading_delay := 1.0

#level timer
var timer_running := false
var current_level_timer := 0.0
var total_timer := 0.0
var time_string := "":
	set(_value):
		time_string = _value
		S.UpdateLevelTimer.emit(time_string)
var tot_timer_string := ""

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	S.LoadScene.connect(_load_scene)
	S.LoadSceneFromPath.connect(_load_from_path)
	S.GameReady.connect(_set_game)
	S.CarParked.connect(_car_parked)
	S.PauseGame.connect(_pause_game)
	S.StartLevelTimer.connect(_start_timer)

func _physics_process(_delta: float) -> void:
	if is_loading:
		loading_status = ResourceLoader.load_threaded_get_status(to_load, progress)
		#print("loading ", to_load , ": ", progress[0]*100, "%")
		if loading_status == ResourceLoader.THREAD_LOAD_LOADED:
			if !load_complete:
				load_complete = true
				_complete_load()
	
	if is_playing and timer_running:
		current_level_timer += _delta
		time_string = get_time_string(current_level_timer)

func _start_timer() -> void:
	timer_running = true

func _pause_game(_value := false) -> void:
	get_tree().set_deferred("paused", _value)

func _load_from_path(_path := "") -> void:
	#print("Received load from path signal: ", _path)
	if _path:
		var loaded = load(_path)
		get_tree().change_scene_to_packed.call_deferred(loaded)

func _load_scene(_id := "") -> void:
	#print("received load scene signal for id: ", _id)
	S.ToggleDisplay.emit("loading_screen", true)
	S.ToggleDisplay.emit("gameplay_ui", false)
	time_string = "00.00.000"
	S.PauseGame.emit(true)
	var path = LEVELS.get_level(_id)
	if path == "": 
		push_error("Level list does not contain ", _id)
		S.ToggleDisplay.emit("loading_screen", false)
		return
	
	if active_level != null: 
		var temp = active_level
		game.remove_child.call_deferred(temp)
		temp.queue_free.call_deferred()
		
	to_load = path
	is_loading = true
	load_complete = false
	ResourceLoader.load_threaded_request(to_load)

func _complete_load() -> void:
	is_loading = false
	var new_world = ResourceLoader.load_threaded_get(to_load)
	
	active_level = new_world.instantiate()
	game.add_child.call_deferred(active_level)
	await get_tree().create_timer(loading_delay).timeout
	S.ToggleDisplay.emit("loading_screen", false)
	S.PauseGame.emit(false)

func _set_game(_game:Game) -> void:
	if _game != null:
		game = _game
		S.LoadScene.emit("main_menu")

func _car_parked():
	timer_running = false
	await get_tree().create_timer(1).timeout
	total_timer += current_level_timer
	current_level_timer = 0.0
	tot_timer_string = get_time_string(total_timer)
	S.ToggleDisplay.emit("result_screen", true)
	S.PauseGame.emit(true)

func get_time_string(_timer := 0.0) -> String:
	var msec := fmod(_timer, 1) * 100
	var sec := fmod(_timer, 60)
	var mins := fmod(_timer, 3600) / 60
	return "%02d:%02d.%03d" % [mins, sec, msec]
