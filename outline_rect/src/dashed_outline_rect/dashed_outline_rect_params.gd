@tool
extends "../outline_rect/outline_rect_params.gd"

@export var dash_size: float = 4.0
@export var gap_size: float = 2.0


func _init(
	outline_color_: Color = Color.BLACK,
	fill_color_: Color = Color(1, 1, 1, 0),
	outline_thickness_: float = 5.0,
	dash_size_: float = 4.0,
	gap_size_: float = 2.0
) -> void:
	super(outline_color_, fill_color_, outline_thickness_)
	dash_size = dash_size_
	gap_size = gap_size_
