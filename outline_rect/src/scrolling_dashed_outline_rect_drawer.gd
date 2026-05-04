@tool
## Utility for drawing filled rectangles with scrolling dashed outlines from any CanvasItem.

const OutlineDrawer := preload("outline_rect_drawer.gd")
const DashedOutlineRectDrawer := preload("dashed_outline_rect_drawer.gd")


## Parameter object for scrolling dashed outline rect drawing.
class Params:
	extends DashedOutlineRectDrawer.Params

	var scroll: float = 0.0

	func _init(rect_: Rect2 = Rect2()) -> void:
		super(rect_)


## Draws fill first, then scrolling dashed outline, using the supplied CanvasItem as the draw target.
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
		params.gap_size,
		params.scroll
	)


## Draws a scrolling dashed outline for the given rect.
static func draw_outline(
	target: CanvasItem,
	rect: Rect2,
	outline_color: Color,
	thickness: float,
	dash_size: float,
	gap_size: float,
	scroll: float
) -> void:
	var start := rect.position
	var end := rect.end

	var x_offset := Vector2(thickness / 2.0, 0)
	var y_offset := Vector2(0, thickness / 2.0)

	_draw_line(target, start - y_offset, Vector2(start.x, end.y) + y_offset, outline_color, thickness, dash_size, gap_size, -scroll)
	_draw_line(target, Vector2(end.x, start.y) - y_offset, end + y_offset, outline_color, thickness, dash_size, gap_size, scroll)
	_draw_line(target, start - x_offset, Vector2(end.x, start.y) + x_offset, outline_color, thickness, dash_size, gap_size, scroll)
	_draw_line(target, Vector2(start.x, end.y) - x_offset, end + x_offset, outline_color, thickness, dash_size, gap_size, -scroll)


## Draws a dashed line segment between two points with a scroll offset.
static func _draw_line(
	target: CanvasItem,
	start: Vector2,
	end: Vector2,
	outline_color: Color,
	thickness: float,
	dash_size: float,
	gap_size: float,
	line_scroll: float
) -> void:
	var dash_size_pixels := thickness * dash_size
	var gap_size_pixels := thickness * gap_size
	var difference := end - start

	var length := difference.length()
	if length == 0.0:
		return

	var segment_length := dash_size_pixels + gap_size_pixels
	for segment in _get_line_segments_range(length, segment_length, dash_size_pixels, fmod(line_scroll, length)):
		target.draw_line(
			lerp(start, end, segment[0] / length),
			lerp(start, end, segment[1] / length),
			outline_color,
			thickness
		)


## Returns `[start, end]` pairs for each visible dash segment.
static func _get_line_segments_range(
	line_length: float,
	segment_length: float,
	segment_fill: float,
	line_scroll: float
) -> Array[Array]:
	var starts := _get_line_segments_start(line_length, segment_length, line_scroll)
	var results: Array[Array] = []

	for start in starts:
		results.append([maxf(0.0, start), clampf(start + segment_fill, 0.0, line_length)])

	return results


## Returns start positions for each dash segment along a line, with scrolling applied.
static func _get_line_segments_start(line_length: float, segment_length: float, line_scroll: float) -> Array[float]:
	if segment_length <= 0.0:
		return []

	var unbounded_start := line_scroll
	while unbounded_start > 0.0:
		unbounded_start -= segment_length

	var length_to_cover := line_length - unbounded_start

	var results: Array[float] = []
	var n_segments: int = ceili(length_to_cover / segment_length)

	for segment_index in range(n_segments):
		results.append(unbounded_start + segment_index * segment_length)

	return results
