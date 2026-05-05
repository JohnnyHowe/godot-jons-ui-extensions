extends Node

@export var target: LayoutEaser

@export_group("Child References")
@export var target_t: Slider
@export var current_t: Slider
@export var pingpong: CheckButton
@export var pingpong_speed: Slider


var _ping_pong_t: float = 0


func _ready() -> void:
	target_t.value_changed.connect(func(new_value):
		target.target_t = new_value
		_ping_pong_t = new_value
	)

	current_t.value_changed.connect(func(new_value):
		target.current_t = new_value
		_ping_pong_t = new_value
	)


func _process(delta: float) -> void:
	target_t.set_value_no_signal(target.target_t)
	current_t.set_value_no_signal(target.current_t)
	_update_ping_poing(delta)


func _update_ping_poing(delta:float)-> void:
	if not pingpong.button_pressed:
		return

	_ping_pong_t += delta * pingpong_speed.value
	_ping_pong_t = fmod(_ping_pong_t, 1)

	target.target_t = pingpong(_ping_pong_t * 2, 1)
