@tool
## Utility for drawing filled rectangles with outlines from any CanvasItem.


## Parameter object for outline rect drawing.
class Params:
	extends RefCounted

	var rect: Rect2
	var outline_color: Color = Color.BLACK
	var fill_color: Color = Color(1, 1, 1, 0)
	var outline_thickness: float = 5.0
	var screen_space_thickness: bool = false
	var draw_transform_x: float = 1.0

	func _init(
		rect_: Rect2 = Rect2()
	) -> void:
		rect = rect_


## Draws fill first, then outline, using the supplied CanvasItem as the draw target.
static func draw(target: CanvasItem, params: Params) -> void:
	draw_fill(target, params.rect, params.fill_color)
	var rect_and_thickness := get_outline_rect_and_thickness(
		params.rect,
		params.outline_thickness,
		params.screen_space_thickness,
		params.draw_transform_x
	)
	draw_outline(target, rect_and_thickness[0], params.outline_color, rect_and_thickness[1])


## Draws the filled rectangle.
static func draw_fill(target: CanvasItem, rect: Rect2, fill_color: Color) -> void:
	target.draw_rect(rect, fill_color)


## Draws the outline for the given rect.
static func draw_outline(
	target: CanvasItem,
	rect: Rect2,
	outline_color: Color,
	thickness: float
) -> void:
	target.draw_rect(rect, outline_color, false, thickness)


## Returns `[rect: Rect2, thickness: float]` for the supplied rect and settings.
static func get_outline_rect_and_thickness(
	rect: Rect2,
	outline_thickness: float,
	screen_space_thickness: bool,
	draw_transform_x: float
) -> Array:
	var draw_thickness := outline_thickness

	if screen_space_thickness and draw_transform_x != 0.0:
		draw_thickness = outline_thickness / draw_transform_x

	draw_thickness = min(draw_thickness, rect.size.x / 2.0, rect.size.y / 2.0)

	var thickness_vector := Vector2.ONE * draw_thickness
	var outline_rect := Rect2(rect.position + thickness_vector / 2.0, rect.size - thickness_vector)
	return [outline_rect, draw_thickness]
