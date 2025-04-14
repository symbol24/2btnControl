class_name LoaderData extends Resource


@export var level_array:Array[LevelData] = []
@export var main_menu:LevelData

var current_level:int = 0
var levels:Dictionary[int, LevelData] = {}


func get_level(_id:Variant) -> LevelData:
	if _id is StringName:
		if _id == &"next":
			current_level += 1
			return levels[current_level] if levels.has(current_level) else null
		elif _id == &"current":
			return levels[current_level] if levels.has(current_level) else null
		elif _id == &"continue":
			var ids:Array = PD.data.levels.keys()
			if ids.is_empty(): current_level = 1
			else:
				ids.sort()
				current_level = ids[-1] + 1
			return levels[current_level] if levels.has(current_level) else null
		elif _id == &"main_menu":
			return main_menu
	elif _id is int and levels.has(_id):
		current_level = _id
		return levels[current_level] if levels.has(current_level) else null
	return null


func construct_levels() -> void:
	for each in level_array:
		levels[each.id] = each
