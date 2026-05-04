@tool
## Draws a filled rectangle with an outline that can be kept in screen space.
class_name OutlineRect
extends Control

const OutlineRectDrawer := preload("outline_rect_drawer.gd")


## Color used for the rectangle outline.
@export var outline_color: Color = Color.BLACK:
	set(value):
		outline_color = value
		_draw_params.outline_color = value
		queue_redraw()

## Fill color for the rectangle interior (alpha respected).
@export var fill_color: Color = Color(1, 1, 1, 0):
	set(value):
		fill_color = value
		_draw_params.fill_color = value
		queue_redraw()

## Outline thickness in pixels or local units, depending on `screen_space_thickness`.
@export var outline_thickness: float = 5.0:
	set(value):
		outline_thickness = value
		_draw_params.outline_thickness = value
		queue_redraw()

## When true, the outline thickness is kept constant in screen space.
@export var screen_space_thickness: bool = true:
	set(value):
		screen_space_thickness = value
		_draw_params.screen_space_thickness = value
		queue_redraw()


## Last transform scale used to detect screen-space thickness changes.
var _last_draw_transform_x: float
var _draw_params := OutlineRectDrawer.Params.new()


func _ready() -> void:
	_sync_draw_params()


## Syncs the cached draw parameters from the current node state.
func _sync_draw_params() -> void:
	_draw_params.rect = Rect2(Vector2.ZERO, size)
	_draw_params.outline_color = outline_color
	_draw_params.fill_color = fill_color
	_draw_params.outline_thickness = outline_thickness
	_draw_params.screen_space_thickness = screen_space_thickness
	if is_inside_tree():
		_last_draw_transform_x = get_viewport().get_final_transform().x.x
	_draw_params.draw_transform_x = _last_draw_transform_x


## Tracks viewport scale changes so the outline can be redrawn in screen space.
func _process(_delta: float) -> void:
	if not screen_space_thickness:
		return

	var new_transform_x = get_viewport().get_final_transform().x.x
	if new_transform_x == _last_draw_transform_x:
		return

	_last_draw_transform_x = new_transform_x
	_draw_params.draw_transform_x = new_transform_x
	queue_redraw()


## Redraws the outline when the control is resized.
func _notification(what) -> void:
	if what == NOTIFICATION_RESIZED:
		_draw_params.rect = Rect2(Vector2.ZERO, size)
		queue_redraw()
		

func _draw() -> void:
	OutlineRectDrawer.draw(self, _draw_params)


## Returns `[rect: Rect2, thickness: float]` for the current size and settings.
func _get_outline_rect_and_thickness() -> Array:
	return OutlineRectDrawer.get_outline_rect_and_thickness(
		_draw_params.rect,
		_draw_params.outline_thickness,
		_draw_params.screen_space_thickness,
		_draw_params.draw_transform_x
	)
