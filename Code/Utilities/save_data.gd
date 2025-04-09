class_name SaveData extends Resource


# LEVELS {id:StringName, uid:String, score:int}
@export var levels:Array[Dictionary] = []


# SETTINGS

# Language
@export var language:int = 0


# AUDIO
@export var master_volume := 0.7
@export var sfx_volume := 0.7
@export var music_volume := 0.7
