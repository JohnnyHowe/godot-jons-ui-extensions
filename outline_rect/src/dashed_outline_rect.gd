@tool
## OutlineRect with dashed segments and optional scrolling animation.
class_name DashedOutlineRect
extends OutlineRect

const DashedOutlineRectDrawer := preload("dashed_outline_rect_drawer.gd")


var _dashed_draw_params := DashedOutlineRectDrawer.Params.new()


## Length of each dash, in multiples of outline thickness.
@export var dash_size: float = 4:
	set(value):
		dash_size = value
		_sync_draw_params()
		queue_redraw()

## Length of each gap, in multiples of outline thickness.
@export var gap_size: float = 2:
	set(value):
		gap_size = value
		_sync_draw_params()
		queue_redraw()


func _draw() -> void:
	DashedOutlineRectDrawer.draw(self, _dashed_draw_params)


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
