class_name ParkingSpot extends Area2D

const CAR_PARKED = preload("res://Data/Audio/car_parked.tres")

func parked():
	S.PlayAudio.emit(CAR_PARKED)
	S.CarParked.emit()
