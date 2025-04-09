class_name Settings extends TBControl


@onready var btn_close: Button = %btn_close
@onready var btn_reset: Button = %btn_reset
@onready var ob_language: OptionButton = %ob_language
@onready var slider_master: HSlider = %slider_master
@onready var slider_music: HSlider = %slider_music
@onready var slider_sfx: HSlider = %slider_sfx

var pending:bool = false


func _ready() -> void:
	btn_close.pressed.connect(_btn_close_pressed)
	btn_reset.pressed.connect(_btn_reset_pressed)
	ob_language.item_selected.connect(_ob_language_selected)
	slider_master.value_changed.connect(_slider_master_changed)
	slider_music.value_changed.connect(_slider_music_changed)
	slider_sfx.value_changed.connect(_slider_sfx_changed)
	S.PopupResult.connect(_receive_popup_result)


func toggle_display(_visible := true) -> void:
	visible = _visible
	ob_language.select(PD.data.language)
	slider_master.value = PD.data.master_volume
	slider_music.value = PD.data.music_volume
	slider_sfx.value = PD.data.sfx_volume
	pending = false
	

func _btn_close_pressed() -> void:
	if pending:
		S.DisplayPopup.emit(&"settings_pending_changes", tr(&"settings_changes_title"), tr(&"settings_changes_description"), 0)
	else:
		hide()
		S.ToggleDisplay.emit(Ui.previous, true)


func _btn_reset_pressed() -> void:
	S.DisplayPopup.emit(&"settings_reset", tr(&"settings_reset_title"), tr(&"settings_reset_description"), 0)


func _ob_language_selected(value:int) -> void:
	pending = true
	var lang = GM.get_locale_from_int(value)
	TranslationServer.set_locale(lang)


func _slider_master_changed(value:float) -> void:
	pending = true
	S.UpdateAudioVolume.emit(&"Master", value)


func _slider_music_changed(value:float) -> void:
	pending = true
	S.UpdateAudioVolume.emit(&"Music", value)


func _slider_sfx_changed(value:float) -> void:
	pending = true
	S.UpdateAudioVolume.emit(&"SFX", value)


func _reset() -> void:
	ob_language.select(0)
	var lang = GM.get_locale_from_int(ob_language.selected)
	TranslationServer.set_locale(lang)
	PD.data.master_volume = Audio.DEFAULT.master_volume
	PD.data.music_volume = Audio.DEFAULT.music_volume
	PD.data.sfx_volume = Audio.DEFAULT.sfx_volume
	slider_master.value = Audio.DEFAULT.master_volume
	slider_music.value = Audio.DEFAULT.music_volume
	slider_sfx.value = Audio.DEFAULT.sfx_volume
	S.UpdateAudioVolume.emit(&"Master", slider_master.value)
	S.UpdateAudioVolume.emit(&"Music", slider_music.value)
	S.UpdateAudioVolume.emit(&"SFX", slider_sfx.value)
	pending = false
	PD.save()


func _confirm_changes() -> void:
	pending = false
	PD.data.language = ob_language.selected
	PD.data.master_volume = slider_master.value
	PD.data.music_volume = slider_music.value
	PD.data.sfx_volume = slider_sfx.value
	PD.save()
	hide()
	S.ToggleDisplay.emit(Ui.previous, true)


func _cancel_changes_and_close() -> void:
	ob_language.select(PD.data.language)
	var lang = GM.get_locale_from_int(ob_language.selected)
	TranslationServer.set_locale(lang)
	slider_master.value = PD.data.master_volume
	slider_music.value = PD.data.music_volume
	slider_sfx.value = PD.data.sfx_volume
	S.UpdateAudioVolume.emit(&"Master", slider_master.value)
	S.UpdateAudioVolume.emit(&"Music", slider_music.value)
	S.UpdateAudioVolume.emit(&"SFX", slider_sfx.value)
	pending = false
	hide()
	S.ToggleDisplay.emit(Ui.previous, true)


func _receive_popup_result(id:StringName, result:bool) -> void:
	print(id, " ", result )
	match id:
		&"settings_pending_changes":
			if result: _confirm_changes()
			else: _cancel_changes_and_close()
		&"settings_reset":
			if result: _reset()
		_:
			pass
