class_name TBPopup extends PanelContainer


@onready var popup_title: Label = %popup_title
@onready var popup_text: RichTextLabel = %popup_text
@onready var timer: Label = %timer
@onready var btn_confirm: Button = %btn_confirm
@onready var btn_cancel: Button = %btn_cancel
@onready var popup_timer: Timer = %popup_timer

var popup_id:StringName = &""
var time:int = 0:
	set(value):
		time = value
		timer.text = str(time)


func _ready() -> void:
	S.DisplayPopup.connect(_display_popup)
	popup_timer.timeout.connect(_timer_timeout)
	btn_confirm.pressed.connect(_btn_confirm_pressed)
	btn_cancel.pressed.connect(_btn_cancel_pressed)


func _display_popup(id:StringName, title:String, description:String, _timer:int = 0) -> void:
	get_parent().move_child(self, get_parent().get_child_count())
	popup_id = id
	popup_title.text = title
	popup_text.text = description
	show()
	if _timer > 0:
		timer.show()
		time = _timer
		popup_timer.start()
	else:
		timer.hide()
	btn_confirm.grab_focus()


func _timer_timeout() -> void:
	time -= 1
	if time > 0: popup_timer.start()
	elif time == 0: _btn_cancel_pressed()


func _btn_confirm_pressed() -> void:
	hide()
	S.PopupResult.emit(popup_id, true)
	popup_id = &""


func _btn_cancel_pressed() -> void:
	hide()
	S.PopupResult.emit(popup_id, false)
	popup_id = &""
