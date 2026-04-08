class_name Spring2D
extends RefCounted

var position: Vector2:
	get:
		return Vector2(_x_spring.position, _y_spring.position)
	set(value):
		_x_spring.position = value.x
		_y_spring.position = value.y

var velocity: Vector2:
	get:
		return Vector2(_x_spring.velocity, _y_spring.velocity)
	set(value):
		_x_spring.velocity = value.x
		_y_spring.velocity = value.y

var target: Vector2:
	get:
		return Vector2(_x_spring.target, _y_spring.target)
	set(value):
		_x_spring.target = value.x
		_y_spring.target = value.y


var stiffness := 200.0
var damping := 20.0

var _x_spring := Spring1D.new()
var _y_spring := Spring1D.new()


func _init(
	initial_position := Vector2.ZERO,
	initial_target := Vector2.ZERO,
	initial_stiffness := 200.0,
	initial_damping := 20.0
):
	position = initial_position
	target = initial_target
	stiffness = initial_stiffness
	damping = initial_damping


func step(delta: float) -> Vector2:
	_x_spring.stiffness = stiffness
	_x_spring.damping = damping
	_x_spring.step(delta)

	_y_spring.stiffness = stiffness
	_y_spring.damping = damping
	_y_spring.step(delta)
	
	return position


func snap(value: Vector2) -> void:
	_x_spring.snap(value.x)
	_y_spring.snap(value.y)


func _to_string() -> String:
	return "Spring2D(position=%s, velocity=%s, target=%s)" % [position, velocity, target]
