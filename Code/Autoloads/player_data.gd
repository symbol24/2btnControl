extends Node

const FOLDER = "user://save/"
const FILE = "game.save"
const JSONTHING = "VVRASG#$f2"

var data:SaveData

func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
