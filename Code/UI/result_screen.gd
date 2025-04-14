class_name ResultScreen extends TBControl


const STAREMPTY:String = "uid://dekt3kors81kr"
const STARFULL:String = "uid://7fh3btgdw4do"


@onready var star_1: TextureRect = %star1
@onready var star_2: TextureRect = %star2
@onready var star_3: TextureRect = %star3
@onready var star_score: TextureRect = %star_score
@onready var target_score: Label = %target_score
@onready var last_score: Label = %last_score
@onready var high_score: Label = %high_score
@onready var level_time: Label = %level_time
@onready var fastest_time: Label = %fastest_time
@onready var cones_hit: Label = %cones_hit
@onready var least_cones_hit: Label = %least_cones_hit
@onready var cones_hit_label: Label = %cones_hit_label
@onready var least_cones_label: Label = %least_cones_label
@onready var result_text: Label = %result_text
@onready var continue_button: Button = %continue
@onready var restart: Button = %restart
@onready var exit: Button = %exit
@onready var bronze: Label = %bronze
@onready var silver: Label = %silver
@onready var gold: Label = %gold

var full:CompressedTexture2D = null:
	get:
		if full == null: full = load(STARFULL) as CompressedTexture2D
		return full
var empty:CompressedTexture2D = null:
	get:
		if empty == null: empty = load(STAREMPTY) as CompressedTexture2D
		return empty


func _ready() -> void:
	continue_button.pressed.connect(_continue_pressed)
	restart.pressed.connect(_restart_pressed)
	exit.pressed.connect(_exit_pressed)


func _continue_pressed() -> void:
	PD.save()
	S.LoadScene.emit(&"next")
	hide()


func _restart_pressed() -> void:
	S.LoadScene.emit(&"current")
	hide()


func _exit_pressed() -> void:
	S.LoadScene.emit(&"main_menu")
	hide()


func toggle_display(_visible := true) -> void:
	visible = _visible
	if _visible:
		if GM.level_data:
			if GM.level_data.has_cones:
				cones_hit.show()
				least_cones_hit.show()
				cones_hit_label.show()
				least_cones_label.show()
			else:
				cones_hit.hide()
				least_cones_hit.hide()
				cones_hit_label.hide()
				least_cones_label.hide()
			bronze.text = GM.get_time_string(GM.level_data.times[&"bronze"])
			silver.text = GM.get_time_string(GM.level_data.times[&"silver"])
			gold.text = GM.get_time_string(GM.level_data.times[&"gold"])
				
			if PD.data.levels.has(GM.level_data.id):
				_toggle_stars(PD.data.levels[GM.level_data.id][&"stars"])
				last_score.text = str(PD.data.levels[GM.level_data.id][&"last_score"])
				high_score.text = str(PD.data.levels[GM.level_data.id][&"high_score"])
				target_score.text = str(GM.level_data.score_star)
				if PD.data.levels[GM.level_data.id][&"high_score"] >= GM.level_data.score_star:
					star_score.texture = full
				else: star_score.texture = empty
				level_time.text = GM.get_time_string(PD.data.levels[GM.level_data.id][&"last_time"])
				fastest_time.text = GM.get_time_string(PD.data.levels[GM.level_data.id][&"fastest_time"])
				cones_hit.text = str(PD.data.levels[GM.level_data.id][&"cones_hit"])
				least_cones_hit.text = str(PD.data.levels[GM.level_data.id][&"least_cones"])
				
		continue_button.grab_focus()


func _toggle_stars(count:int) -> void:
	match count:
		1:
			star_1.texture = full
			star_2.texture = empty
			star_3.texture = empty
		2:
			star_1.texture = full
			star_2.texture = full
			star_3.texture = empty
		3:
			star_1.texture = full
			star_2.texture = full
			star_3.texture = full
		_:
			star_1.texture = empty
			star_2.texture = empty
			star_3.texture = empty
			
