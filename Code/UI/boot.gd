class_name Boot extends Node2D

const GAME = "res://Scenes/Utilities/game.tscn"

@onready var animator: AnimationPlayer = %animator

var step := 0
var step_running := false

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("backward") or Input.is_action_just_pressed("forward"):
		_skip()

func _ready() -> void:
	animator.animation_finished.connect(_anim_check)
	_start()

func _start() -> void:
	animator.play("godot")

func _anim_check(_anim_name:="") -> void:
	if _anim_name == "godot": animator.play("logo")
	elif _anim_name == "logo": S.LoadSceneFromPath.emit(GAME)

func _skip() -> void:
	if animator.current_animation == "godot": animator.play("logo")
	elif animator.current_animation == "logo": S.LoadSceneFromPath.emit(GAME)
		
