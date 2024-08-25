class_name ResultScreen extends TBControl

@onready var level_time: RichTextLabel = %level_time
@onready var total_time: RichTextLabel = %total_time

@onready var result_text: RichTextLabel = %result_text
@onready var continue_button: Button = %continue
@onready var restart: Button = %restart
@onready var exit: Button = %exit

func _ready() -> void:
	super()
	continue_button.pressed.connect(_continue_pressed)
	restart.pressed.connect(_restart_pressed)
	exit.pressed.connect(_exit_pressed)

func _continue_pressed():
	S.LoadScene.emit("next")
	hide()

func _restart_pressed():
	S.LoadScene.emit("current")
	hide()

func _exit_pressed():
	S.LoadScene.emit("main_menu")
	hide()

func _toggle_display(_id = "", _visible := true) -> void:
	if _id == id:
		set_deferred("visible", _visible)
		level_time.text = GM.time_string
		total_time.text = GM.tot_timer_string
		if _visible: continue_button.grab_focus()
