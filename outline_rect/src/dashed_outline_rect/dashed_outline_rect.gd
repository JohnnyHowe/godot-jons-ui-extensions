@tool
## OutlineRect with dashed segments.
class_name DashedOutlineRect
extends Control

const DashedOutlineRectDrawer := preload("dashed_outline_rect_drawer.gd")
const DashedOutlineRectParams := preload("dashed_outline_rect_params.gd")


@export var draw_params := DashedOutlineRectParams.new():
	set(value):
		if value == null:
			value = DashedOutlineRectParams.new()
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

	var draw_params_copy: DashedOutlineRectParams = draw_params.duplicate()
	draw_params_copy.rect = Rect2(Vector2.ZERO, size)
	DashedOutlineRectDrawer.draw(self, draw_params_copy)
