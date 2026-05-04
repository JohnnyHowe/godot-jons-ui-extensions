@tool
## OutlineRect with dashed segments.
class_name DashedOutlineRect
extends Control

const Drawer := preload("dashed_outline_rect_drawer.gd")
const Params := preload("dashed_outline_rect_params.gd")


@export var draw_params := Params.new():
	set(value):
		if value == null:
			value = Params.new()
		if value == draw_params:
			return
		draw_params = value
		queue_redraw()


func _process(_delta: float) -> void:
	if not visible:
		return
	queue_redraw()


## Redraws the outline when the control is resized.
func _notification(what) -> void:
	if what == NOTIFICATION_RESIZED:
		queue_redraw()


func _draw() -> void:
	if not visible:
		return
	if not draw_params:
		return

	var draw_params_copy: Params = draw_params.duplicate()
	draw_params_copy.rect = Rect2(Vector2.ZERO, size)
	Drawer.draw(self, draw_params_copy)
