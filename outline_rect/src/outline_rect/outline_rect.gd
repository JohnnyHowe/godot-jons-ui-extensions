@tool
## Draws a filled rectangle with an outline that can be kept in screen space.
class_name OutlineRect
extends Control

const OutlineRectDrawer := preload("outline_rect_drawer.gd")
const OutlineRectParams := preload("outline_rect_params.gd")


@export var draw_params := OutlineRectParams.new():
	set(value):
		if value == null:
			value = OutlineRectParams.new()
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

	var draw_params_copy := draw_params.duplicate()
	draw_params_copy.outline_thickness
	draw_params_copy.rect = Rect2(Vector2.ZERO, size)

	OutlineRectDrawer.draw(self , draw_params_copy)
