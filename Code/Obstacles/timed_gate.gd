class_name TimedGate extends Gate

@export var delay_before_closing := 3.0

var gate_open := true
var active := false
var timer := 0.0:
	set(_value):
		timer = _value
		if timer >= delay_before_closing:
			timer = 0.0
			_toggle_gate(false)

func _ready() -> void:
	S.StartLevelTimer.connect(_toggle_active)

func _physics_process(_delta: float) -> void:
	if gate_open and active: timer += _delta

func _toggle_active() -> void:
	active = true
