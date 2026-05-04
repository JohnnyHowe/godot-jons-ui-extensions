@tool
extends "../dashed_outline_rect/dashed_outline_rect_params.gd"

@export var scroll: float = 0.0


func _init(
	outline_color_: Color = Color.BLACK,
	fill_color_: Color = Color(1, 1, 1, 0),
	outline_thickness_: float = 5.0,
	dash_size_: float = 4.0,
	gap_size_: float = 2.0,
	scroll_: float = 0.0
) -> void:
	super(outline_color_, fill_color_, outline_thickness_, dash_size_, gap_size_)
	scroll = scroll_
