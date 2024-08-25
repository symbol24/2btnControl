class_name LoaderParkingSpot extends ParkingSpot

@export var load_to := ""

func parked():
	#print("triggering parked")
	if load_to != "":
		S.PlayAudio.emit(CAR_PARKED)
		if load_to == "level_selector": S.ToggleDisplay.emit("level_selector", true)
		else: S.LoadScene.emit(load_to)
