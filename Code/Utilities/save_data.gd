class_name SaveData extends Resource


# LEVELS {int:{score:int, fastet_time:float. last_time:float, medal:int, cones_hit:int}}
@export var levels:Dictionary = {}


# SETTINGS

# Language
@export var language:int = 0
@export var use_dyslexia_friendly_font:bool = false
var default_use_dyslexia_friendly_font:bool = false

# Video
@export var window_size:Vector2i = Vector2i(1280, 720)
var window_size_default:Vector2i = Vector2i(1280, 720)
@export var window_mode:Settings.Window_Mode = Settings.Window_Mode.FULLSCREEN
var default_window_mode:Settings.Window_Mode = Settings.Window_Mode.FULLSCREEN

# AUDIO
@export var master_volume := 0.7
@export var sfx_volume := 0.7
@export var music_volume := 0.7
@export var replace_audio:bool = false

# CONTROLS
@export var forward:Array[Key] = [KEY_W, KEY_UP]
var default_forward:Array[Key] = [KEY_W, KEY_UP]
@export var backward:Array[Key] = [KEY_S, KEY_DOWN]
var default_backward:Array[Key] = [KEY_S, KEY_DOWN]
@export var pause:Key = KEY_ESCAPE
var default_pause:Key = KEY_ESCAPE
