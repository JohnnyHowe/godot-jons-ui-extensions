extends Container

@export var resize_speed := 12.0

var _target_size := Vector2.ZERO

func _ready() -> void:
	for child in get_children():
		_hook_child(child)
	_recalculate()

func _notification(what: int) -> void:
	if what == NOTIFICATION_SORT_CHILDREN:
		for child: Control in _get_control_children():
			# Keep child where it already is, just ensure its size is respected if needed.
			# Or replace this with your own layout logic.
			fit_child_in_rect(child, Rect2(child.position, child.size))

func _process(delta: float) -> void:
	size = size.lerp(_target_size, 1.0 - exp(-resize_speed * delta))

func _get_minimum_size() -> Vector2:
	var rect := _get_children_bounds()
	return rect.size

func _recalculate() -> void:
	_target_size = _get_children_bounds().size
	update_minimum_size()
	queue_sort()

func _get_children_bounds() -> Rect2:
	var first := true
	var rect := Rect2()

	for child: Control in _get_control_children():
		var child_rect := Rect2(child.position, child.get_combined_minimum_size())
		if first:
			rect = child_rect
			first = false
		else:
			rect = rect.merge(child_rect)

	return rect if not first else Rect2(Vector2.ZERO, Vector2.ZERO)

func _get_control_children() -> Array[Control]:
	var out: Array[Control] = []
	for child in get_children():
		if child is Control:
			out.append(child)
	return out

func _hook_child(child: Node) -> void:
	if child is Control:
		child.resized.connect(_recalculate)
		child.minimum_size_changed.connect(_recalculate)
		child.visibility_changed.connect(_recalculate)
