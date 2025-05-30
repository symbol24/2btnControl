class_name PauseMenu extends TBControl


@onready var pause_continue: Button = %pause_continue
@onready var pause_restart: Button = %pause_restart
@onready var pause_exit: Button = %pause_exit


func _ready() -> void:
	pause_continue.pressed.connect(_continue_pressed)
	pause_restart.pressed.connect(_restart_pressed)
	pause_exit.pressed.connect(_exit_pressed)


func _continue_pressed() -> void:
	_hide_self()
	S.PauseGame.emit(false)


func _restart_pressed() -> void:
	GM.timer_running = false
	S.LoadScene.emit(&"current")
	_hide_self()


func _exit_pressed() -> void:
	S.LoadScene.emit("main_menu")
	_hide_self()


func toggle_display(_visible := true) -> void:
	visible = _visible
	if _visible: pause_continue.grab_focus.call_deferred()
	S.PauseGame.emit(_visible)
	S.ToggleMouse.emit(_visible)


func _hide_self() -> void:
	hide()
	S.ToggleMouse.emit(false)
