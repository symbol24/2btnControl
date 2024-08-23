class_name PlayerCar extends CharacterBody2D

@export var data:PlayerCarData

@onready var front_detector: Area2D = %front_detector
@onready var back_detector: Area2D = %back_detector

#Movement and rotation
var current_speed := 0.0
var move_forward := false
var move_backward := false
var rotation_on := false
var rotate_timer_on := false
var rotate_delay := 0.5
var rotate_timer := 0.0:
	set(_value):
		rotate_timer = _value
		if rotate_timer >= rotate_delay:
			rotate_timer = 0.0
			rotation_on = true
			rotate_timer_on = false

#parked
var parked := false
var front_in := false
var back_in := false
var parked_timer := 0.0:
	set(_value):
		parked_timer = _value
		if parked_timer >= data.parked_detection_delay:
			_check_if_parked()
			parked_timer = 0.0

func _ready() -> void:
	front_detector.area_entered.connect(_front_detector_enter)
	front_detector.area_exited.connect(_front_detector_exit)
	back_detector.area_entered.connect(_back_detector_enter)
	back_detector.area_exited.connect(_back_detector_exit)

func _physics_process(_delta: float) -> void:
	if front_in or back_in:
		parked_timer += _delta
	
	if rotate_timer_on:
		rotate_timer += _delta
	
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
	
	if rotation_on:
		var speed_lost = (data.speed - current_speed)/data.speed if current_speed > 0.0 else (data.speed + current_speed)/data.speed
		rotation_degrees = _rotate(_delta, rotation_degrees, data.turn_angle, speed_lost)
		
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
	print("area is ParkingSpot ", _area is ParkingSpot)
	if _area is ParkingSpot:
		front_in = true

func _front_detector_exit(_area) -> void:
	if _area is ParkingSpot:
		front_in = false
		
func _back_detector_enter(_area) -> void:
	if _area is ParkingSpot:
		back_in = true

func _back_detector_exit(_area) -> void:
	if _area is ParkingSpot:
		back_in = false

func _check_if_parked() -> void:
	if front_in and back_in and current_speed <= 0.1 and current_speed >= -0.1 and !parked:
		parked = true
		print("PARKED!")
		S.CarParked.emit()
