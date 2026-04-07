@tool
class_name OutlineRect
extends Control


@export var outline_color: Color = Color.BLACK:
	set(value):
		outline_color = value
		queue_redraw()

@export var fill_color: Color = Color(1, 1, 1, 0):
	set(value):
		fill_color = value
		queue_redraw()

@export var outline_thickness: float = 5.0:
	set(value):
		outline_thickness = value
		queue_redraw()

@export var screen_space_thickness: bool = true:
	set(value):
		screen_space_thickness = value
		queue_redraw()


var _last_draw_transform_x: float


func _process(_delta: float) -> void:
	if not screen_space_thickness:
		return

	var new_transform_x = get_viewport().get_final_transform().x.x
	if new_transform_x == _last_draw_transform_x:
		return

	_last_draw_transform_x = new_transform_x
	queue_redraw()


func _notification(what) -> void:
	if what == NOTIFICATION_RESIZED:
		queue_redraw()
		

func _draw() -> void:
	_draw_fill()
	_draw_outline()


func _draw_fill() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), fill_color)


func _draw_outline() -> void:
	var rect_and_thickness = _get_outline_rect_and_thickness()
	draw_outline(rect_and_thickness[0], rect_and_thickness[1])


func draw_outline(rect: Rect2, thickness: float) -> void:
	draw_rect(rect, outline_color, false, thickness)


## [rect: Rect2, thickness: float]
func _get_outline_rect_and_thickness() -> Array:
	var draw_thickness := outline_thickness

	# convert to screen space?
	if screen_space_thickness:
		draw_thickness = outline_thickness / _last_draw_transform_x

	# ensure outline_thickness will not cause overdraw
	draw_thickness = min(draw_thickness, size.x / 2, size.y / 2)

	var thickness_vector = Vector2.ONE * draw_thickness
	var outline_rect := Rect2(thickness_vector / 2, size - thickness_vector)

	return [outline_rect, draw_thickness]
