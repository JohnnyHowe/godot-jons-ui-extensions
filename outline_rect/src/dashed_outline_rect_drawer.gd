@tool
## Utility for drawing filled rectangles with dashed outlines from any CanvasItem.

const OutlineDrawer := preload("outline_rect_drawer.gd")


## Parameter object for dashed outline rect drawing.
class Params:
	extends OutlineDrawer.Params

	var dash_size: float = 4.0
	var gap_size: float = 2.0


## Draws fill first, then dashed outline, using the supplied CanvasItem as the draw target.
static func draw(target: CanvasItem, params: Params) -> void:
	OutlineDrawer.draw_fill(target, params.rect, params.fill_color)
	var rect_and_thickness := OutlineDrawer.get_outline_rect_and_thickness(
		params.rect,
		params.outline_thickness,
		params.screen_space_thickness,
		params.draw_transform_x
	)
	draw_outline(
		target,
		rect_and_thickness[0],
		params.outline_color,
		rect_and_thickness[1],
		params.dash_size,
		params.gap_size
	)


## Draws a dashed outline for the given rect.
static func draw_outline(
	target: CanvasItem,
	rect: Rect2,
	outline_color: Color,
	thickness: float,
	dash_size: float,
	gap_size: float
) -> void:
	var start := rect.position
	var end := rect.end

	var x_offset := Vector2(thickness / 2.0, 0)
	var y_offset := Vector2(0, thickness / 2.0)

	_draw_line(target, start - y_offset, Vector2(start.x, end.y) + y_offset, outline_color, thickness, dash_size, gap_size)
	_draw_line(target, Vector2(end.x, start.y) - y_offset, end + y_offset, outline_color, thickness, dash_size, gap_size)
	_draw_line(target, start - x_offset, Vector2(end.x, start.y) + x_offset, outline_color, thickness, dash_size, gap_size)
	_draw_line(target, Vector2(start.x, end.y) - x_offset, end + x_offset, outline_color, thickness, dash_size, gap_size)


## Draws a dashed line segment between two points.
static func _draw_line(
	target: CanvasItem,
	start: Vector2,
	end: Vector2,
	outline_color: Color,
	thickness: float,
	dash_size: float,
	gap_size: float
) -> void:
	var dash_size_pixels := thickness * dash_size
	var gap_size_pixels := thickness * gap_size
	var difference := end - start

	var length := difference.length()
	if length == 0.0:
		return

	var segment_length := dash_size_pixels + gap_size_pixels
	for segment in _get_line_segments_range(length, segment_length, dash_size_pixels):
		target.draw_line(
			lerp(start, end, segment[0] / length),
			lerp(start, end, segment[1] / length),
			outline_color,
			thickness
		)


## Returns `[start, end]` pairs for each visible dash segment.
static func _get_line_segments_range(line_length: float, segment_length: float, segment_fill: float) -> Array[Array]:
	var starts := _get_line_segments_start(line_length, segment_length)
	var results: Array[Array] = []

	for start in starts:
		results.append([maxf(0.0, start), clampf(start + segment_fill, 0.0, line_length)])

	return results


## Returns start positions for each dash segment along a line.
static func _get_line_segments_start(line_length: float, segment_length: float) -> Array[float]:
	if segment_length <= 0.0:
		return []

	var results: Array[float] = []
	var n_segments: int = ceili(line_length / segment_length)

	for segment_index in range(n_segments):
		results.append(segment_index * segment_length)

	return results
