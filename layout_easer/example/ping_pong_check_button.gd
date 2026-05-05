extends CheckButton


@export var target: LayoutEaser
@export var speed: float = 1

var _t: float = 0


func _process(delta: float) -> void:
	pressed.connect(func(): _t = target.current_t)

	if not button_pressed:
		return

	_t += delta * speed
	_t = fmod(_t, 1)

	target.current_t = pingpong(_t * 2, 1)


func set_speed(value) -> void:
	speed = value
