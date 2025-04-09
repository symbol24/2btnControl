class_name Boot extends Node2D


const GAME = "res://Scenes/Utilities/game.tscn"
const VROOM = preload("uid://bi040cx55j2y2")


@onready var animator: AnimationPlayer = %animator


var step := 0
var step_running := false
var current := &"godot"


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("backward") or Input.is_action_just_pressed("forward"):
		_anim_check(current)


func _ready() -> void:
	if not OS.has_feature("editor"): Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	animator.animation_finished.connect(_anim_check)
	await get_tree().create_timer(1).timeout
	animator.play(current)


func _anim_check(_anim_name:="") -> void:
	if _anim_name == &"godot":
		current = &"logo"
		animator.play(&"RESET")
	elif _anim_name == &"RESET":
		animator.play(current)
	elif _anim_name == &"logo": 
		current = &"save"
		animator.play(&"RESET")
	elif _anim_name == &"save": 
		S.LoadSceneFromPath.emit(GAME)


func _play_vroom() -> void:
	S.PlayAudio.emit(VROOM, false)
