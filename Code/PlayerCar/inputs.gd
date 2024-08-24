class_name Inputs extends Node2D

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

func _ready() -> void:
	parent = get_parent() as PlayerCar

func _input(event: InputEvent) -> void:
	var button_pressed := false
	if event.is_action_pressed("reset") and parent != null and !signal_sent:
		S.ResetLevel.emit()
		signal_sent = true
	elif event.is_action_pressed("forward") and parent != null and parent.accept_input:
		parent.move_forward = true
		button_pressed = true
	elif event.is_action_released("forward") and parent != null:
		parent.move_forward = false
	elif event.is_action_pressed("backward") and parent != null and parent.accept_input:
		parent.move_backward = true
		button_pressed = true
	elif event.is_action_released("backward") and parent != null:
		parent.move_backward = false
	elif event.is_action_pressed("pause") and parent != null and !signal_sent:
		var pause = true if GM.is_playing else false
		S.ToggleDisplay.emit("pause_menu", pause)
		S.PauseGame.emit(pause)
		signal_sent = true
		
	if button_pressed and !level_timer_started:
		S.StartLevelTimer.emit()
		level_timer_started = true
	
func _physics_process(_delta: float) -> void:
	if signal_sent: signal_timer += _delta
