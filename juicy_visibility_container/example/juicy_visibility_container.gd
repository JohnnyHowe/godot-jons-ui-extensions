@tool
class_name JuicyVisibilityContainer
extends MarginContainer


@export var target_visible: bool = true

@export var spring_stiffness: float = 200:
	set(value):
		spring_stiffness = value
		_spring.stiffness = spring_stiffness

@export var spring_damping: float = 20:
	set(value):
		spring_damping = value
		_spring.damping = spring_damping

var _spring := Spring1D.new()


func set_target_visible(target_visible: bool) -> void:
	self.target_visible = target_visible


func _process(delta: float) -> void:
	_update_spring(delta)
	scale = Vector2.ONE * _spring.position


func _update_spring(delta: float) -> void:
	_spring.target = 1 if target_visible else 0

	delta = clamp(delta, 1.0 / 15, 1.0 / 500)
	_spring.step(delta)

	if _spring.position < 0:
		_spring.position = 0
		_spring.velocity = 0

