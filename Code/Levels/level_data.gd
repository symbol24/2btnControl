class_name LevelData extends Resource


@export var id:int = 0
@export var uid:String
@export var times:Dictionary[StringName, float] = {
													&"gold":0.0,
													&"silver":0.0,
													&"bronze":0.0,
													}
@export var has_cones:bool = false
@export var score_star:int = 100
@export var starting_score:int = 10000
@export var objective_count:int = 0
@export var car:GM.Vehicle_Type
