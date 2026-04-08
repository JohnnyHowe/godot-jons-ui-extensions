@tool
class_name JuicyVisibilityContainer
extends MarginContainer


@export var target_visible: bool = true:
	get:
		return _target_visible
	set(value):
		if not respond_to_child_visibility:
			_target_visible = value

var _target_visible: bool = true

@export var respond_to_child_visibility: bool = false:
	set(value):
		respond_to_child_visibility = value
		_child_visibility_changed()


@export_group("Spring Settings")
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
	if not respond_to_child_visibility:
		return
	
	_target_visible = false
	for child in get_children():
		if child is Control:
			if child.visible:
				_target_visible = true
				return
