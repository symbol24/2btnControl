class_name PlayerCar extends CharacterBody2D

const CRASH = preload("res://Data/Audio/crash.tres")
const BARKS = preload("res://Data/Audio/barks.tres")
const BOINGS = preload("res://Data/Audio/boings.tres")

@export var data:PlayerCarData
@export var car_colors:CarColorData

@onready var front_detector: Area2D = %front_detector
@onready var back_detector: Area2D = %back_detector
@onready var outline: Sprite2D = %outline
@onready var body: Sprite2D = %body
@onready var windows: Sprite2D = %windows
@onready var crash_detector: Area2D = %crash_detector

#Movement and rotation
var accept_input := true
var accept_input_timer := 0.0:
	set(_value):
		accept_input_timer = _value
		if accept_input_timer >= data.crash_input_delay:
			accept_input_timer = 0.0
			accept_input = true
			if oil_slick: oil_slick = false
var current_speed := 0.0
var move_forward := false
var move_backward := false
var rotation_on := false
var rotate_timer_on := false
var rotate_timer := 0.0:
	set(_value):
		rotate_timer = _value
		if rotate_timer >= data.rotate_delay:
			rotate_timer = 0.0
			rotation_on = true
			rotate_timer_on = false

#level start
var start_transform

#parked
var parking_spot:ParkingSpot
var parked := false
var front_in := false:
	set(_value):
		front_in = _value
		_check_if_parked()
var back_in := false:
	set(_value):
		back_in = _value
		_check_if_parked()
var parked_timer := 0.0:
	set(_value):
		parked_timer = _value
		if parked_timer >= data.parked_detection_delay:
			_check_if_parked()
			parked_timer = 0.0

#Conditions
var oil_slick := false

func _ready() -> void:
	S.ResetLevel.connect(_reset_car)
	crash_detector.body_entered.connect(_crash_detecter_body_entered)
	crash_detector.area_entered.connect(_crash_detecter_area_entered)
	front_detector.area_entered.connect(_front_detector_enter)
	front_detector.area_exited.connect(_front_detector_exit)
	back_detector.area_entered.connect(_back_detector_enter)
	back_detector.area_exited.connect(_back_detector_exit)
	start_transform = transform
	_set_car_color()
	var level = get_tree().get_first_node_in_group("level")
	if level and (!level.has_meta("no_gameplay_ui") or !level.get_meta("no_gameplay_ui")):
		S.ToggleDisplay.emit("gameplay_ui", true)

func _physics_process(_delta: float) -> void:
	if front_in and back_in:
		parked_timer += _delta
	if !accept_input:
		accept_input_timer += _delta
	if rotate_timer_on:
		rotate_timer += _delta
	
	if accept_input and !parked:
		if move_forward:
			velocity = _move(_delta, 1, velocity)
			if rotation_on: rotation_on = false
		elif move_backward:
			velocity = _move(_delta, -1, velocity)
			if !rotation_on: rotate_timer_on = true
		else:
			if velocity != Vector2.ZERO:
				velocity = _move(_delta, 0, velocity)
			if velocity == Vector2.ZERO:
				if rotation_on: rotation_on = false
	
		if rotation_on and !parked:
			var speed_lost = (data.speed - current_speed)/data.speed if current_speed > 0.0 else (data.speed + current_speed)/data.speed
			rotation_degrees = _rotate(_delta, rotation_degrees, data.turn_angle, speed_lost)
	
	if oil_slick:
		rotation_on = true
		rotation_degrees = _rotate(_delta, rotation_degrees, data.oil_slick_rot, 0)
	
	move_and_slide()
		
func _move(_delta:=0.0, _direction:=0.0, _velocity := Vector2.ZERO) -> Vector2:
	var new_vel = _velocity
	
	if _direction > 0 or _direction < 0:
		new_vel = new_vel.move_toward(_direction * Vector2(data.speed,0).rotated(rotation), _delta * data.acceleration)
		current_speed = move_toward(current_speed, data.speed*_direction, _delta * data.acceleration)
	elif _direction == 0.0:
		new_vel = new_vel.move_toward(Vector2.ZERO, _delta * data.friction)
		current_speed = move_toward(current_speed, 0, _delta * data.friction)
	
	return new_vel

func _rotate(_delta := 0.0, _rotation := 0.0, _angle := 0.0, _speed_lost := 0.0) -> float:
	var new_rotation := _rotation
	#print("_speed_lost ", _speed_lost)
	new_rotation = move_toward(_rotation, _rotation + (_angle * (1-_speed_lost)), _delta * data.rotation_speed)

	return new_rotation

func _front_detector_enter(_area) -> void:
	#print("area is ParkingSpot ", _area is ParkingSpot)
	if _area is ParkingSpot:
		if parking_spot == null: parking_spot = _area
		front_in = true

func _front_detector_exit(_area) -> void:
	if _area is ParkingSpot:
		front_in = false
		
func _back_detector_enter(_area) -> void:
	if _area is ParkingSpot:
		if parking_spot == null: parking_spot = _area
		back_in = true

func _back_detector_exit(_area) -> void:
	if _area is ParkingSpot:
		back_in = false

func _check_if_parked() -> void:
	if front_in and back_in and _check_if_slow_speed(current_speed) and !parked:
		parked = true
		velocity = Vector2.ZERO
		current_speed = 0.0
		print("PARKED!")
		if parking_spot != null: parking_spot.parked()

func _check_if_slow_speed(_speed := 0.0):
	return _speed >= data.parked_slow_speed[0] and _speed <= data.parked_slow_speed[1]

func _reset_car() -> void:
	parked = false
	velocity = Vector2.ZERO
	transform = start_transform

func push(_direction:Vector2) -> void:
	if _direction:
		accept_input_timer = 0.0
		accept_input = false
		velocity = _direction

func oil_spin() -> void:
		accept_input_timer = 0.0
		accept_input = false
		oil_slick = true

func _set_car_color() -> void:
	var is_metallic := randi_range(0,1)
	if is_metallic == 1: body.frame = 1
	var color = car_colors.colors.pick_random()
	body.set_deferred("modulate", color)

func _crash_detecter_body_entered(_body) -> void:
	if _body is Bumper:
		return
	var chance = randf_range(0,1)
	if chance <= data.bark_chance: 
		S.PlayAudio.emit(BARKS)
		return
	S.PlayAudio.emit(CRASH)

func _crash_detecter_area_entered(_area) -> void:
	if _area.get_parent() and _area.get_parent() is Bumper:
		S.PlayAudio.emit(BOINGS)
