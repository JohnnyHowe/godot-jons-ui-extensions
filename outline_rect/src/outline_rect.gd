@tool
## Draws a filled rectangle with an outline that can be kept in screen space.
class_name OutlineRect
extends Control

const Drawer := preload("outline_rect_drawer.gd")


## Color used for the rectangle outline.
@export var outline_color: Color = Color.BLACK:
	set(value):
		outline_color = value
		queue_redraw()

## Fill color for the rectangle interior (alpha respected).
@export var fill_color: Color = Color(1, 1, 1, 0):
	set(value):
		fill_color = value
		queue_redraw()

## Outline thickness in pixels or local units, depending on `screen_space_thickness`.
@export var outline_thickness: float = 5.0:
	set(value):
		outline_thickness = value
		queue_redraw()

## When true, the outline thickness is kept constant in screen space.
@export var screen_space_thickness: bool = true:
	set(value):
		screen_space_thickness = value
		queue_redraw()


## Last transform scale used to detect screen-space thickness changes.
var _last_draw_transform_x: float


## Tracks viewport scale changes so the outline can be redrawn in screen space.
func _process(_delta: float) -> void:
	if not screen_space_thickness:
		return

	var new_transform_x = get_viewport().get_final_transform().x.x
	if new_transform_x == _last_draw_transform_x:
		return

	_last_draw_transform_x = new_transform_x
	queue_redraw()


## Redraws the outline when the control is resized.
func _notification(what) -> void:
	if what == NOTIFICATION_RESIZED:
		queue_redraw()
		

## Draws fill first, then outline.
func _draw() -> void:
	_draw_fill()
	_draw_outline()


## Draws the filled rectangle.
func _draw_fill() -> void:
	Drawer.draw_fill(self , _make_draw_params().rect, fill_color)


## Computes and draws the outline.
func _draw_outline() -> void:
	var rect_and_thickness = _get_outline_rect_and_thickness()
	draw_outline(rect_and_thickness[0], rect_and_thickness[1])


## Draws the outline for the given rect and thickness.
func draw_outline(rect: Rect2, thickness: float) -> void:
	Drawer.draw_outline(self , rect, outline_color, thickness)


## Returns `[rect: Rect2, thickness: float]` for the current size and settings.
func _get_outline_rect_and_thickness() -> Array:
	var params := _make_draw_params()
	return Drawer.get_outline_rect_and_thickness(
		params.rect,
		params.outline_thickness,
		params.screen_space_thickness,
		params.draw_transform_x
	)


## Returns draw parameters shared with utility-based callers.
func _make_draw_params() -> Drawer.Params:
	return Drawer.Params.new(
		Rect2(Vector2.ZERO, size),
		outline_color,
		fill_color,
		outline_thickness,
		screen_space_thickness,
		_last_draw_transform_x
	)
