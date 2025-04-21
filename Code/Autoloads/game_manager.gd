extends Node

const LEVELS = preload("res://Data/levels.tres")
const SCORECOLOR:Color = Color.RED
const CRASHSCOREVALUE:int = 10
const CONESCOREVALUE:int = 100
const RESETCSOREVALUE:int = 1000
const MISSEDOBJECTIVEVALUE:int = 500


var is_playing:bool:
	get:
		return !get_tree().paused

#Levels and loading
var level_data:LevelData = null
var active_level:Node2D
var game:Game
var is_loading := false
var to_load := ""
var load_complete := false
var loading_status := 0.0
var progress := []
var extra_loading := false
var loading_delay := 1.0

#level timer
var levels:LoaderData = null
var timer_running := false
var current_level_timer := 0.0
var time_string := "":
	set(_value):
		time_string = _value
		S.UpdateLevelTimer.emit(time_string)
var level_cones_hit := 0
var level_score:int = 0
var objectives_complete:int = 0
var car_resets:int = 0
var car_crashes:int = 0


func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	S.LoadScene.connect(_load_scene)
	S.LoadSceneFromPath.connect(_load_from_path)
	S.GameReady.connect(_set_game)
	S.CarParked.connect(_car_parked)
	S.PauseGame.connect(_pause_game)
	S.StartLevelTimer.connect(_start_timer)
	S.ConeHit.connect(_cone_hit)
	S.CarCrash.connect(_car_crash)
	S.ResetLevel.connect(_car_reset)
	S.ObjectiveComplete.connect(_objective_complete)
	levels = LEVELS
	levels.construct_levels()


func _process(_delta: float) -> void:
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


func get_time_string(_timer := 0.0) -> String:
	var msec := fmod(_timer, 1) * 1000
	var sec := fmod(_timer, 60)
	var mins := fmod(_timer, 3600) / 60
	return "%02d:%02d.%03d" % [mins, sec, msec]


func get_locale_from_int(id:int) -> String:
	var lang:String = "en"
	match id:
		1:
			lang = "fr"
		2:
			lang = "fr-CA"
		_:
			pass
	return lang


func _start_timer() -> void:
	timer_running = true


func _pause_game(_value := false) -> void:
	get_tree().set_deferred(&"paused", _value)


func _load_from_path(_path := "") -> void:
	#print("Received load from path signal: ", _path)
	if _path:
		var loaded := load(_path)
		get_tree().change_scene_to_packed.call_deferred(loaded)


func _load_scene(_id:Variant) -> void:
	if _id is String: _id = _id as StringName
	level_data = null
	load_complete = false
	if active_level and active_level.is_in_group(&"level"): S.ToggleDisplay.emit(&"gameplay_ui", false)
	S.ToggleDisplay.emit(&"loading_screen", true)
	_reset_level_stuff()
	S.PauseGame.emit(true)
	level_data = levels.get_level(_id)
	assert(level_data != null, "Level list does not contain %s" % _id)
	
	if active_level != null: 
		var temp := active_level
		game.remove_child.call_deferred(temp)
		temp.queue_free.call_deferred()
		
	to_load = level_data.uid
	is_loading = true
	ResourceLoader.load_threaded_request(to_load)


func _complete_load() -> void:
	is_loading = false
	var new_world := ResourceLoader.load_threaded_get(to_load)
	
	active_level = new_world.instantiate()
	game.add_child.call_deferred(active_level)
	var wait_timer := get_tree().create_timer(loading_delay)
	await wait_timer.timeout
	if active_level.is_in_group(&"level"): S.ToggleDisplay.emit(&"gameplay_ui", true)
	S.ToggleDisplay.emit(&"loading_screen", false)
	S.PauseGame.emit(false)


func _set_game(_game:Game) -> void:
	if _game != null:
		game = _game
		S.LoadScene.emit(&"main_menu")


func _car_parked() -> void:
	timer_running = false
	if level_data and level_data.id > 0:
		current_level_timer = snapped(current_level_timer, 0.0001)
		#print("level gold: %s to current_time: %s" % [get_time_string(level_data.times[&"gold"]), current_level_timer])
		var fastest:float = current_level_timer
		var cones:int = level_cones_hit
		var high_score:int = max(level_data.starting_score + level_score, 0)
		var objectives:int = objectives_complete
		var resets:int = car_resets
		var stars:int = _get_star_count(current_level_timer, level_data.times)
		var crashes:int = car_crashes
		
		if PD.data.levels.has(level_data.id):
			if PD.data.levels[level_data.id][&"stars"] >= stars: stars = PD.data.levels[level_data.id][&"stars"]
			if PD.data.levels[level_data.id][&"fastest_time"] <= fastest: fastest = PD.data.levels[level_data.id][&"fastest_time"]
			if PD.data.levels[level_data.id][&"high_score"] >= high_score: high_score = PD.data.levels[level_data.id][&"high_score"]
			if PD.data.levels[level_data.id][&"cones_hit"] <= cones: cones = PD.data.levels[level_data.id][&"cones_hit"]
			if PD.data.levels[level_data.id][&"objectives_complete"] <= objectives: objectives = PD.data.levels[level_data.id][&"objectives_complete"]
			if PD.data.levels[level_data.id][&"car_resets"] <= resets: resets = PD.data.levels[level_data.id][&"car_resets"]
			if PD.data.levels[level_data.id][&"crashes"] <= crashes: crashes = PD.data.levels[level_data.id][&"crashes"]

		var level_result:Dictionary = {
			&"high_score":high_score,
			&"last_score":max(level_data.starting_score + level_score, 0),
			&"fastest_time":fastest,
			&"last_time":current_level_timer, 
			&"stars": stars,
			&"cones_hit":level_cones_hit,
			&"least_cones":cones,
			&"objectives_complete":objectives,
			&"car_resets":resets,
			&"crashes":crashes,
		}
		PD.data.levels[level_data.id] = level_result
		
	await get_tree().create_timer(1).timeout
	current_level_timer = 0.0
	S.ToggleDisplay.emit(&"result_screen", true)
	S.PauseGame.emit(true)


func _cone_hit() -> void:
	level_cones_hit += 1
	level_score -= CONESCOREVALUE


func _car_crash() -> void:
	car_crashes += 1
	level_score -= CRASHSCOREVALUE


func _car_reset() -> void:
	car_resets += 1
	level_score -= RESETCSOREVALUE
	

func _objective_complete() -> void:
	objectives_complete += 1


func _get_star_count(time:float, times:Dictionary[StringName, float]) -> int:
	if time <= times[&"gold"]: return 3
	elif time <= times[&"silver"]: return 2
	elif time <= times[&"bronze"]: return 1
	return 0


func _reset_level_stuff() -> void:
	current_level_timer = 0.0
	level_cones_hit = 0
	level_score = 0
	time_string = "00.00.000"
	objectives_complete = 0
	car_resets = 0
	
