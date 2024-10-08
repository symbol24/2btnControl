class_name LoaderData extends Resource

@export var levels:Array[Dictionary] = []
@export var level_order:Array[String] = []

var current_level := ""

func get_level(_id := "") -> String:
	if _id == "current": _id = current_level
	elif _id == "next": _id = _get_next(current_level)
	#print("id = ", _id)
	for each in levels:
		if each.has("id") and each["id"] == _id:
			current_level = _id
			return each["path"]
	return ""

func _get_next(_current := "") -> String:
	for i in level_order.size() - 1:
		if level_order[i] == _current: 
			if level_order[i+1] != null or level_order[i+1] != "":
				return level_order[i+1]
	return "level_001"
