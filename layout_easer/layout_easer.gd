@tool
class_name LayoutEaser
extends Control
## Animates a control between collapsed and expanded layout states by interpolating
## its position and size over time using a configurable easing curve.

const _DebugDrawer := preload("./layout_easer_debug_drawer.gd")

@export var _enabled: bool = true

@export var _subject: Control
@export var _expanded_layout: Control
@export var _collapsed_layout: Control

@export var _transition_time: float = 1
@export var _transition_curve: Curve
@export var _start_expanded: bool = false


@export_range(0, 1) var current_t: float:
	set(value):
		current_t = clamp(value, 0, 1)

@export_group("Debug")
@export var _debug_draw: bool = false:
	set(value):
		if value == _debug_draw: return
		_debug_draw = value
		if _debug_draw: _enable_debug_drawer()
		else: _disable_debug_drawer()
			
@warning_ignore_start("UNUSED_PRIVATE_CLASS_VARIABLE")
@export var _debug_draw_z: int = 4000
@export var _collapsed_layout_debug_draw_params := DashedOutlineRect.Params.new(
	Color.BLUE
)
@export var _expanded_layout_debug_draw_params := DashedOutlineRect.Params.new(
	Color.GREEN
)
@export var _subject_debug_draw_params := DashedOutlineRect.Params.new(
	Color.WHITE
)
@warning_ignore_restore("UNUSED_PRIVATE_CLASS_VARIABLE")

var target_t: float:
	set(value):
		target_t = clamp(value, 0, 1)

var _debug_draw_node: _DebugDrawer


func _ready() -> void:
	if Engine.is_editor_hint():
		return

	if _start_expanded:
		expand_instant.call_deferred()
	else:
		collapse_instant.call_deferred()


## Starts an animated transition toward the expanded layout.
func expand() -> void:
	target_t = 1


## Immediately snaps the subject to the expanded layout.
func expand_instant() -> void:
	_instant_set_t(1)


## Starts an animated transition toward the collapsed layout.
func collapse() -> void:
	target_t = 0


## Immediately snaps the subject to the collapsed layout.
func collapse_instant() -> void:
	_instant_set_t(0)


func _instant_set_t(value: float) -> void:
	target_t = value
	current_t = value


func _process(delta: float) -> void:
	if not _enabled:
		return

	_update_layout()

	if Engine.is_editor_hint():
		return

	_step_current_t(delta)


func _step_current_t(delta: float) -> void:
	var normalized_delta = delta / _transition_time

	var change_sign: int = -1 if target_t < current_t else 1
	var max_t_change: float = abs(target_t - current_t)

	current_t += change_sign * min(max_t_change, normalized_delta)


## Applies the eased interpolation to the subject's position and size.
func _update_layout() -> void:
	if not _enabled:
		return

	if _subject == null or _expanded_layout == null or _collapsed_layout == null:
		return

	var eased_t = current_t
	if _transition_curve != null:
		eased_t = _transition_curve.sample(current_t)

	_subject.anchor_top = lerp(_collapsed_layout.anchor_top, _expanded_layout.anchor_top, eased_t)
	_subject.anchor_bottom = lerp(_collapsed_layout.anchor_bottom, _expanded_layout.anchor_bottom, eased_t)
	_subject.anchor_left = lerp(_collapsed_layout.anchor_left, _expanded_layout.anchor_left, eased_t)
	_subject.anchor_right = lerp(_collapsed_layout.anchor_right, _expanded_layout.anchor_right, eased_t)
	_subject.global_position = _collapsed_layout.global_position.lerp(_expanded_layout.global_position, eased_t)
	_subject.size = _collapsed_layout.size.lerp(_expanded_layout.size, eased_t)


#region Debug Drawing

func _enable_debug_drawer() -> void:
	if _debug_draw_node == null:
		_create_debug_draw_node()
	_debug_draw_node.visible = true


func _create_debug_draw_node() -> void:
	_debug_draw_node = _DebugDrawer.new(self )
	add_child(_debug_draw_node, false, INTERNAL_MODE_FRONT)


func _disable_debug_drawer() -> void:
	if _debug_draw_node:
		_debug_draw_node.visible = false


func _exit_tree() -> void:
	if _debug_draw_node:
		_debug_draw_node.queue_free()

#endregion
