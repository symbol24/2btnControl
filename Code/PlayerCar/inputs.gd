class_name Inputs extends Node2D

const CAR_GOES_BRR = preload("res://Data/Audio/car_goes_brr.tres")

var parent:PlayerCar
var signal_sent := false
var signal_delay := 0.3
var signal_timer := 0.0:
	set(_value):
		signal_timer = _value
		if signal_timer >= signal_delay:
			signal_sent = false
			signal_timer = 0
var level_timer_started := false
var sfx_sent := false
var accept_inputs := true

func _ready() -> void:
	parent = get_parent() as PlayerCar
	S.CarParked.connect(_car_parked)

func _input(event: InputEvent) -> void:
	if accept_inputs:
		var button_pressed := false
		if Input.is_action_just_pressed("forward") and Input.is_action_just_pressed("backward"):
			S.ResetLevel.emit()
			return
		if event.is_action_pressed("forward") and parent != null:
			parent.move_forward = true
			button_pressed = true
			if !sfx_sent:
				S.PlayAudio.emit(CAR_GOES_BRR)
				sfx_sent = true
		elif event.is_action_released("forward") and parent != null:
			parent.move_forward = false
			if sfx_sent: sfx_sent = false
		elif event.is_action_pressed("backward") and parent != null:
			parent.move_backward = true
			button_pressed = true
			if !sfx_sent:
				S.PlayAudio.emit(CAR_GOES_BRR)
				sfx_sent = true
		elif event.is_action_released("backward") and parent != null:
			parent.move_backward = false
			if sfx_sent: sfx_sent = false
		elif event.is_action_pressed("pause") and parent != null and !signal_sent:
			var pause = true if GM.is_playing else false
			S.ToggleDisplay.emit("pause_menu", pause)
			S.PauseGame.emit(pause)
			signal_sent = true
			
		if button_pressed and !level_timer_started:
			var level = get_tree().get_first_node_in_group("level")
			if level and (!level.has_meta("no_gameplay_ui") or !level.get_meta("no_gameplay_ui")):
				S.StartLevelTimer.emit()
				level_timer_started = true
	
func _physics_process(_delta: float) -> void:
	if signal_sent: signal_timer += _delta

func _car_parked():
	accept_inputs = false
	
