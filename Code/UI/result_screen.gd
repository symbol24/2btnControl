class_name ResultScreen extends TBControl

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

func _restart_pressed():
	S.LoadScene.emit("current")

func _exit_pressed():
	S.LoadScene.emit("main_menu")
