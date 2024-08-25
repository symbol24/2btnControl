class_name PauseMenu extends TBControl

@onready var pause_continue: Button = %pause_continue
@onready var pause_restart: Button = %pause_restart
@onready var pause_exit: Button = %pause_exit


func _ready() -> void:
	super()
	pause_continue.pressed.connect(_continue_pressed)
	pause_restart.pressed.connect(_restart_pressed)
	pause_exit.pressed.connect(_exit_pressed)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		var pause := true if GM.is_playing else false
		S.ToggleDisplay.emit("pause_menu", pause)
		S.PauseGame.emit(pause)

func _continue_pressed() -> void:
	hide()
	S.PauseGame.emit(false)

func _restart_pressed() -> void:
	S.LoadScene.emit("current")
	hide()

func _exit_pressed() -> void:
	S.LoadScene.emit("main_menu")
	hide()

func _toggle_display(_id := "", _visible := true) -> void:
	if _id == id:
		if _visible: pause_continue.grab_focus()
		set_deferred("visible", _visible)
