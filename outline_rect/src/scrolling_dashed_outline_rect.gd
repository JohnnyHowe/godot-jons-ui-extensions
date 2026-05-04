@tool
## OutlineRect with dashed segments and optional scrolling animation.
class_name ScrollingDashedOutlineRect
extends OutlineRect


## Length of each dash, in multiples of outline thickness.
@export var dash_size: float = 1:
	set(value):
		dash_size = value
		queue_redraw()

## Length of each gap, in multiples of outline thickness.
@export var gap_size: float = 1:
	set(value):
		gap_size = value
		queue_redraw()

## Scroll speed for the dash pattern (units per second).
@export var scroll_speed: float = 1

## Accumulated scroll offset for the dash pattern.
var _scroll: float = 0:
	set(value):
		if value != _scroll:
			_scroll = value
			queue_redraw()


## Advances the dash scroll over time, while preserving base OutlineRect behavior.
func _process(delta: float) -> void:
	super._process(delta)
	if scroll_speed != 0:
		_scroll += delta * scroll_speed


## Draws a dashed outline around the rect with optional scrolling.
func draw_outline(rect: Rect2, thickness: float) -> void:
	var half_thickness_vector = Vector2.ZERO

	var start = rect.position + half_thickness_vector
	var end = rect.end - half_thickness_vector

	var x_offset := Vector2(thickness / 2, 0)
	var y_offset := Vector2(0, thickness / 2)

	# left
	_draw_line(start - y_offset, Vector2(start.x, end.y) + y_offset, thickness, -_scroll)
	# right
	_draw_line(Vector2(end.x, start.x) - y_offset, end + y_offset, thickness, _scroll)
	# top
	_draw_line(start - x_offset, Vector2(end.x, start.y) + x_offset, thickness, _scroll)
	# bottom
	_draw_line(Vector2(start.x, end.y) - x_offset, end + x_offset, thickness, -_scroll)


## Draws a dashed line segment between two points.
func _draw_line(start: Vector2, end: Vector2, thickness: float, line_scroll: float) -> void:
	var dash_size_pixels := thickness * dash_size
	var gap_size_pixels := thickness * gap_size

	var difference = end - start

	var length: float = difference.length()
	if length == 0:
		return

	var segment_length: float = dash_size_pixels + gap_size_pixels

	for segment in _get_line_segments_range(length, segment_length, dash_size_pixels, fmod(line_scroll, length)):
		var segment_normalized := [segment[0] / length, segment[1] / length]
		draw_line(
			lerp(start, end, segment_normalized[0]),
			lerp(start, end, segment_normalized[1]),
			outline_color,
			thickness
		)


## Returns `[start, end]` pairs for each visible dash segment.
static func _get_line_segments_range(line_length: float, segment_length: float, segment_fill: float, line_scroll: float) -> Array[Array]:
	var starts := _get_line_segments_start(line_length, segment_length, line_scroll)

	var results: Array[Array] = []
	for start in starts:
		results.append([max(0, start), clampf(start + segment_fill, 0, line_length)])
	return results


## _scroll in range [start, end]
## returns start positions
## Returns start positions for each dash segment along a line.
static func _get_line_segments_start(line_length: float, segment_length: float, line_scroll: float) -> Array[float]:
	if segment_length <= 0:
		return []

	# TODO replace with modulo?
	var unbounded_start: float = line_scroll
	while unbounded_start > 0:
		unbounded_start -= segment_length

	var length_to_cover = line_length - unbounded_start

	var results: Array[float] = []

	var n_segments: int = ceil(length_to_cover / segment_length)
	for segment_index in range(n_segments):
		results.append(unbounded_start + segment_index * segment_length)

	return results
