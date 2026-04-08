@tool
class_name JuicyVisibilityContainerRespondsToChildren
extends MarginContainer


@export var spring_stiffness: float = 5000
@export var spring_damping: float = 75

var _spring := Spring1D.new()
var _target_visible: bool = true


func set_target_visible(target_visible: bool) -> void:
	self.target_visible = target_visible


func _process(delta: float) -> void:
	_update_spring(delta)
	scale = Vector2.ONE * _spring.position


func _update_spring(delta: float) -> void:
	_spring.stiffness = spring_stiffness
	_spring.damping = spring_damping
	_spring.target = 1 if _target_visible else 0

	delta = clamp(delta, 1.0 / 15, 1.0 / 500)
	_spring.step(delta)

	if _spring.position < 0:
		_spring.position = 0
		_spring.velocity = 0


#region Child Listeners

func _enter_tree() -> void:
	child_entered_tree.connect(_child_entered_tree)
	child_exiting_tree.connect(_child_exiting_tree)


func _exit_tree() -> void:
	child_entered_tree.disconnect(_child_entered_tree)
	child_exiting_tree.disconnect(_child_exiting_tree)


func _child_entered_tree(child: Node) -> void:
	if child is not Control:
		return

	child = child as Control
	child.visibility_changed.connect(_child_visibility_changed_callback.bind(child))
	_child_visibility_changed()


func _child_exiting_tree(child: Node) -> void:
	if child.visibility_changed.is_connected(_child_visibility_changed_callback):
		child.visibility_changed.disconnect(_child_visibility_changed_callback)
	_child_visibility_changed.call_deferred()



func _child_visibility_changed_callback(child: Control) -> void:
	_child_visibility_changed()


func _child_visibility_changed() -> void:
	_target_visible = false
	for child in get_children():
		if child is Control:
			if child.visible:
				_target_visible = true
				return
