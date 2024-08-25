class_name TBButton extends Button

func _ready() -> void:
	focus_entered.connect(_grabbed)

func _grabbed() -> void:
	#print(name)
	pass
