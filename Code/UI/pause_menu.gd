class_name PauseMenu extends TBControl

@onready var pause_continue: Button = %pause_continue
@onready var pause_restart: Button = %pause_restart
@onready var pause_exit: Button = %pause_exit


func _ready() -> void:
	super()
	pause_continue.pressed.connect(_continue_pressed)
	pause_restart.pressed.connect(_restart_pressed)
	pause_exit.pressed.connect(_exit_pressed)

func _continue_pressed():
	hide()
	S.PauseGame.emit(false)

func _restart_pressed():
	S.LoadScene.emit("current")
	hide()

func _exit_pressed():
	S.LoadScene.emit("main_menu")
	hide()
