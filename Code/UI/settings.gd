class_name Settings extends TBControl


const WINDOW_SIZES:Array[Vector2i] = [Vector2i(3840, 2160), 
									Vector2i(2560, 1440), 
									Vector2i(1920, 1080), 
									Vector2i(1366, 768), 
									Vector2i(1280, 720), 
									Vector2i(1920, 1200), 
									Vector2i(1680, 1050), 
									Vector2i(1440, 900), 
									Vector2i(1280, 800), 
									Vector2i(1024, 768), 
									Vector2i(800, 600), 
									Vector2i(640, 480), 
									]


enum Window_Mode {
					FULLSCREEN = 0,
					WINDOWED = 1,
					BORDERLESS_WINDOWED = 2,
}


@export var display_dyselexia_option:bool = false

@onready var btn_close: Button = %btn_close
@onready var btn_reset: Button = %btn_reset
@onready var ob_language: OptionButton = %ob_language
@onready var slider_master: HSlider = %slider_master
@onready var slider_music: HSlider = %slider_music
@onready var slider_sfx: HSlider = %slider_sfx
@onready var ob_window: OptionButton = %ob_window
@onready var mode_label: Label = %mode_label
@onready var size_label: Label = %size_label
@onready var ob_window_size: OptionButton = %ob_window_size
@onready var dyslexia_label: Label = %dyslexia_label
@onready var btn_dyslexia: Button = %btn_dyslexia

var pending:bool = false
var mode:Window_Mode
var window_size:Vector2i
var use_dyslexia:bool

func _ready() -> void:
	btn_close.pressed.connect(_btn_close_pressed)
	btn_reset.pressed.connect(_btn_reset_pressed)
	ob_language.item_selected.connect(_ob_language_selected)
	slider_master.value_changed.connect(_slider_master_changed)
	slider_music.value_changed.connect(_slider_music_changed)
	slider_sfx.value_changed.connect(_slider_sfx_changed)
	S.PopupResult.connect(_receive_popup_result)
	ob_window.item_selected.connect(_window_mode_changed)
	_populate_window_size()
	ob_window_size.item_selected.connect(_window_size_changed)
	btn_dyslexia.pressed.connect(_btn_dyslexia_pressed)


func toggle_display(_visible := true) -> void:
	visible = _visible
	ob_language.select(PD.data.language)
	slider_master.value = PD.data.master_volume
	slider_music.value = PD.data.music_volume
	slider_sfx.value = PD.data.sfx_volume
	pending = false
	mode = PD.data.window_mode
	if not OS.has_feature("editor") and  (OS.has_feature("linus") or OS.has_feature("windows") or OS.has_feature("macos")):
		mode_label.show()
		ob_window.show()
	else: 
		ob_window.hide()
		mode_label.hide()
	window_size = PD.data.window_size
	_check_display_size()
	if display_dyselexia_option:
		dyslexia_label.show()
		btn_dyslexia.show()
		use_dyslexia = PD.data.use_dyslexia_friendly_font
		if use_dyslexia: btn_dyslexia.text = tr("c_dyslexia_on")
		else: btn_dyslexia.text = tr("c_dyslexia_off")
	else: 
		dyslexia_label.hide()
		btn_dyslexia.hide()
	#ob_language.grab_focus()
	slider_master.grab_focus()
	

func _btn_close_pressed() -> void:
	if pending:
		_toggle_buttons(true)
		S.DisplayPopup.emit(&"settings_pending_changes", tr(&"settings_changes_title"), tr(&"settings_changes_description"), 0)
	else:
		hide()
		S.ToggleDisplay.emit(Ui.previous, true)


func _btn_reset_pressed() -> void:
	_toggle_buttons(true)
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


func _window_mode_changed(value:int) -> void:
	mode = value as Window_Mode
	_set_display_mode(mode)
	_toggle_buttons(true)
	S.DisplayPopup.emit(&"window_mode", "window_mode_title", "window_mode_text", 15)


func _reset_window_mode() -> void:
	mode = PD.data.window_mode
	_set_display_mode(mode)


func _window_size_changed(value:int) -> void:
	window_size = WINDOW_SIZES[value]
	get_window().size = window_size
	_toggle_buttons(false)
	S.DisplayPopup.emit(&"window_size", "window_size_change_title", "window_size_change_text", 15)
	

func _btn_dyslexia_pressed() -> void:
	if use_dyslexia: 
		use_dyslexia = false
		PD.default_theme.default_font = PD.NORMAL_FONT
		btn_dyslexia.text = tr("c_dyslexia_off")
	else: 
		use_dyslexia = true
		PD.default_theme.default_font = PD.DYSLEXIC_FONT
		btn_dyslexia.text = tr("c_dyslexia_on")
	pending = true


func _reset_window_size() -> void:
	window_size = PD.data.window_size
	get_window().size = window_size


func _reset() -> void:
	# Language
	ob_language.select(0)
	var lang = GM.get_locale_from_int(ob_language.selected)
	TranslationServer.set_locale(lang)
	PD.data.language = 0
	# Audio
	PD.data.master_volume = Audio.DEFAULT.master_volume
	PD.data.music_volume = Audio.DEFAULT.music_volume
	PD.data.sfx_volume = Audio.DEFAULT.sfx_volume
	slider_master.value = Audio.DEFAULT.master_volume
	slider_music.value = Audio.DEFAULT.music_volume
	slider_sfx.value = Audio.DEFAULT.sfx_volume
	S.UpdateAudioVolume.emit(&"Master", slider_master.value)
	S.UpdateAudioVolume.emit(&"Music", slider_music.value)
	S.UpdateAudioVolume.emit(&"SFX", slider_sfx.value)
	# Font
	if use_dyslexia: 
		_btn_dyslexia_pressed()
		PD.data.use_dyslexia_friendly_font = PD.data.default_use_dyslexia_friendly_font
	# Window Mode
	#ob_window.select(0)
	#_set_display_mode(PD.data.default_window_mode)
	#PD.data.window_mode = PD.data.default_window_mode
	#_check_display_size()
	pending = false
	
	# Save
	PD.save()


func _confirm_changes() -> void:
	pending = false
	PD.data.language = ob_language.selected
	PD.data.master_volume = slider_master.value
	PD.data.music_volume = slider_music.value
	PD.data.sfx_volume = slider_sfx.value
	PD.data.use_dyslexia_friendly_font = use_dyslexia
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


func _receive_popup_result(_id:StringName, result:bool) -> void:
	_toggle_buttons(false)
	match _id:
		&"settings_pending_changes":
			if result: _confirm_changes()
			else: _cancel_changes_and_close()
		&"settings_reset":
			if result: _reset()
			btn_reset.grab_focus()
		&"window_mode":
			if result:
				PD.data.window_mode = mode
				PD.save()
			else:
				_reset_window_mode()
			_check_display_size()
			ob_window.grab_focus()
		&"window_size":
			if result:
				PD.data.window_size = window_size
				PD.save()
			else:
				_reset_window_size()
			ob_window_size.grab_focus()
		_:
			pass


func _set_display_mode(_mode:Window_Mode) -> void:
	match _mode:
		Window_Mode.BORDERLESS_WINDOWED:
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			get_window().set_size(PD.data.window_size)
		Window_Mode.WINDOWED:
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			get_window().set_size(PD.data.window_size)
		_:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func _toggle_buttons(value:bool = false) -> void:
	btn_close.set_disabled(value)
	btn_reset.set_disabled(value)
	ob_language.set_disabled(value)
	slider_master.set_editable(!value)
	slider_music.set_editable(!value)
	slider_sfx.set_editable(!value)
	ob_window.set_disabled(value)
	ob_window_size.set_disabled(value)


func _check_display_size() -> void:
	if not OS.has_feature("web"):
		if PD.data.window_mode != Window_Mode.FULLSCREEN:
			size_label.show()
			ob_window_size.show()
			ob_window_size.select(_get_int_from_size(window_size))
		else:
			size_label.hide()
			ob_window_size.hide()
	else:
		size_label.hide()
		ob_window_size.hide()


func _populate_window_size() -> void:
	var i:int = 0
	while i < WINDOW_SIZES.size():
		ob_window_size.add_item(str(WINDOW_SIZES[i], i))
		i += 1
	

func _get_int_from_size(_size:Vector2i) -> int:
	var i:int = 0
	for s in WINDOW_SIZES:
		if s == _size:
			return i
		i += 1
	return -1
	
