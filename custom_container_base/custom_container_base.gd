@tool
@abstract
## Base class for custom containers that arrange visible child controls.
class_name CustomContainerBase
extends Container


var _is_arranging := false


func _notification(what: int) -> void:
	if what == NOTIFICATION_SORT_CHILDREN:
		_arrange_with_guard.call_deferred()


func _arrange_with_guard() -> void:
	if _is_arranging:
		return
	_is_arranging = true
	_arrange()
	_is_arranging = false


func _arrange() -> void:
	var children: Array[Control] = []
	for child in get_children():
		if child is Control:
			if child.visible:
				children.append(child)
	arrange_children(children)


@abstract
func arrange_children(visible_children: Array[Control]) -> void
