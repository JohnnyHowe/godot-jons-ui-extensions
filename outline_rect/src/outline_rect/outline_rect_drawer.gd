@tool
## Utility for drawing filled rectangles with outlines from any CanvasItem.

const OutlineRectParams := preload("outline_rect_params.gd")

## Draws fill first, then outline, using the supplied CanvasItem as the draw target.
static func draw(target: CanvasItem, params: OutlineRectParams) -> void:
	draw_fill(target, params.rect, params.fill_color)
	var rect := get_rect_accounting_for_thickness(params.rect, params.outline_thickness)
	draw_outline(target, rect, params.outline_color, params.outline_thickness)


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
static func get_rect_accounting_for_thickness(rect: Rect2, outline_thickness: float) -> Rect2:
	outline_thickness = min(outline_thickness, rect.size.x / 2.0, rect.size.y / 2.0)

	var thickness_vector := Vector2.ONE * outline_thickness
	var outline_rect := Rect2(rect.position + thickness_vector / 2.0, rect.size - thickness_vector)
	return outline_rect
