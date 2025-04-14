class_name LoaderParkingSpot extends ParkingSpot

@export var load_to := &""

func parked():
	S.LoadScene.emit(load_to)
