@tool
## OutlineRect with dashed segments and scrolling animation.
class_name ScrollingDashedOutlineRect
extends Control

const Drawer := preload("scrolling_dashed_outline_rect_drawer.gd")
const Params := preload("scrolling_dashed_outline_rect_params.gd")


@export var draw_params := Params.new():
	set(value):
		if value == null:
			value = Params.new()
		if value == draw_params:
			return
		draw_params = value
		queue_redraw()

## Scroll speed for the dash pattern (units per second).
@export var scroll_speed: float = 1.0


func _process(delta: float) -> void:
	if not visible:
		return

	if draw_params and scroll_speed != 0.0:
		draw_params.scroll += delta * scroll_speed

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


## Returns `[start, end]` pairs for each visible dash segment.
static func _get_line_segments_range(line_length: float, segment_length: float, segment_fill: float, line_scroll: float) -> Array[Array]:
	return Drawer._get_line_segments_range(
		line_length,
		segment_length,
		segment_fill,
		line_scroll
	)


## Returns start positions for each dash segment along a line.
static func _get_line_segments_start(line_length: float, segment_length: float, line_scroll: float) -> Array[float]:
	return Drawer._get_line_segments_start(
		line_length,
		segment_length,
		line_scroll
	)
