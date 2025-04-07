extends Node


const FOLDER = "user://save/"
const FILE = "save.tres"


var data:SaveData = null


func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	_load()
	if data == null:
		save()
	S.UpdateAudioVolume.emit(&"Master", data.master_volume)
	S.UpdateAudioVolume.emit(&"SFX", data.sfx_volume)
	S.UpdateAudioVolume.emit(&"Music", data.master_volume)


func save() -> void:
	if data == null:
		data = SaveData.new()
	
	var error = ResourceSaver.save(data, FOLDER + FILE)
	if error != OK:
		push_error("Save error: ", error_string(error))
	else:
		print("save ok!")


func _load() -> void:
	var dir:DirAccess = _check_folder()
	if dir != null:
		var files:PackedStringArray = dir.get_files()
		for file in files:
			if file == FILE:
				data = load(FOLDER + FILE)
				return


func _check_folder() -> DirAccess:
	var dir:DirAccess = DirAccess.open(FOLDER)
	if dir == null:
		var result = DirAccess.make_dir_absolute(FOLDER)
		if result != OK:
			print_debug("Error creating save folder: ", result)
			return null
	return dir
