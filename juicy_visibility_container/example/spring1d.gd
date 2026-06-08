class_name Spring1D
extends RefCounted

const MAX_DELTA: float = 1.0 / 10
const MIN_DELTA: float = 1.0 / 1000

var position := 0.0
var velocity := 0.0
var target := 0.0

var stiffness := 200.0
var damping := 20.0


func _init(
	initial_position := 0.0,
	initial_target := 0.0,
	initial_stiffness := 200.0,
	initial_damping := 20.0
):
	position = initial_position
	target = initial_target
	stiffness = initial_stiffness
	damping = initial_damping


func step(delta: float) -> float:
	delta = clamp(delta, MIN_DELTA, MAX_DELTA)
	var force = (target - position) * stiffness
	var damp = - velocity * damping
	var acceleration = force + damp

	velocity += acceleration * delta
	position += velocity * delta
	return position


func snap(value: float) -> void:
	position = value
	velocity = 0.0
	target = value


func _to_string() -> String:
	return "Spring1D(position=%s, velocity=%s, target=%s)" % [position, velocity, target]
