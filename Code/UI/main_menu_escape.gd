class_name MainMenuEscape extends TBControl


@onready var btn_how_to: Button = %btn_how_to
@onready var btn_level_select: Button = %btn_level_select
@onready var btn_settings: Button = %btn_settings
@onready var btn_credits: Button = %btn_credits
@onready var btn_quit: Button = %btn_quit
@onready var btn_close: Button = %btn_close
@onready var btn_discord: Button = %btn_discord


func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	btn_how_to.pressed.connect(_btn_how_to_pressed)
	btn_level_select.pressed.connect(_btn_level_select_pressed)
	btn_settings.pressed.connect(_btn_settings_pressed)
	btn_credits.pressed.connect(_btn_credits_pressed)
	btn_quit.pressed.connect(_btn_quit_pressed)
	btn_close.pressed.connect(_btn_close_pressed)
	btn_discord.pressed.connect(_btn_discord_pressed)
	S.PopupResult.connect(_check_popup_result)


func _btn_how_to_pressed() -> void:
	hide()
	S.ToggleDisplay.emit(&"howto", true, id)


func _btn_level_select_pressed() -> void:
	hide()
	S.ToggleDisplay.emit(&"level_selector", true, id)


func _btn_settings_pressed() -> void:
	hide()
	S.ToggleDisplay.emit(&"settings", true, id)


func _btn_credits_pressed() -> void:
	hide()
	S.ToggleDisplay.emit(&"credits", true, id)


func _btn_quit_pressed() -> void:
	S.DisplayPopup.emit(&"quit_popup", "popup_quit_title", "popup_quit_text", 0)


func _btn_close_pressed() -> void:
	hide()
	S.HideMouse.emit()
	S.PauseGame.emit(false)


func _btn_discord_pressed() -> void:
	OS.shell_open("https://discord.gg/53jFqh7GPt")


func toggle_display(_visible := true) -> void:
	visible = _visible
	if _visible: btn_how_to.grab_focus()
	S.PauseGame.emit(_visible)


func _check_popup_result(_id:StringName, result:bool) -> void:
	match _id:
		&"quit_popup":
			if result:
				get_tree().quit()
		_:
			pass
			
