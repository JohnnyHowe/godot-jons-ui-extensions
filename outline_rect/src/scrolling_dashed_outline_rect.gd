@tool
## OutlineRect with dashed segments and optional scrolling animation.
class_name ScrollingDashedOutlineRect
extends OutlineRect

const ScrollingDashedOutlineRectDrawer := preload("scrolling_dashed_outline_rect_drawer.gd")


var _dashed_draw_params := ScrollingDashedOutlineRectDrawer.Params.new()


## Length of each dash, in multiples of outline thickness.
@export var dash_size: float = 1:
	set(value):
		dash_size = value
		_sync_draw_params()
		queue_redraw()

## Length of each gap, in multiples of outline thickness.
@export var gap_size: float = 1:
	set(value):
		gap_size = value
		_sync_draw_params()
		queue_redraw()

## Scroll speed for the dash pattern (units per second).
@export var scroll_speed: float = 1

## Accumulated scroll offset for the dash pattern.
var _scroll: float = 0:
	set(value):
		if value != _scroll:
			_scroll = value
			_sync_draw_params()
			queue_redraw()


## Advances the dash scroll over time, while preserving base OutlineRect behavior.
func _process(delta: float) -> void:
	super._process(delta)
	if scroll_speed != 0:
		_scroll += delta * scroll_speed


func _draw() -> void:
	ScrollingDashedOutlineRectDrawer.draw(self, _dashed_draw_params)


## Syncs the cached dashed draw parameters from the current node state.
func _sync_draw_params() -> void:
	super._sync_draw_params()

	_dashed_draw_params.rect = _draw_params.rect
	_dashed_draw_params.outline_color = _draw_params.outline_color
	_dashed_draw_params.fill_color = _draw_params.fill_color
	_dashed_draw_params.outline_thickness = _draw_params.outline_thickness
	_dashed_draw_params.screen_space_thickness = _draw_params.screen_space_thickness
	_dashed_draw_params.draw_transform_x = _draw_params.draw_transform_x
	_dashed_draw_params.dash_size = dash_size
	_dashed_draw_params.gap_size = gap_size
	_dashed_draw_params.scroll = _scroll


## Returns `[start, end]` pairs for each visible dash segment.
static func _get_line_segments_range(line_length: float, segment_length: float, segment_fill: float, line_scroll: float) -> Array[Array]:
	return ScrollingDashedOutlineRectDrawer._get_line_segments_range(
		line_length,
		segment_length,
		segment_fill,
		line_scroll
	)


## _scroll in range [start, end]
## returns start positions
## Returns start positions for each dash segment along a line.
static func _get_line_segments_start(line_length: float, segment_length: float, line_scroll: float) -> Array[float]:
	return ScrollingDashedOutlineRectDrawer._get_line_segments_start(
		line_length,
		segment_length,
		line_scroll
	)
