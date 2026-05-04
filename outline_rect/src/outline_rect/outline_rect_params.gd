@tool
extends Resource

var rect: Rect2
@export var outline_color: Color = Color.BLACK
@export var fill_color: Color = Color(1, 1, 1, 0)
@export var outline_thickness: float = 5.0


func _init(
	outline_color_: Color = Color.BLACK,
	fill_color_: Color = Color(1, 1, 1, 0),
	outline_thickness_: float = 5.0
) -> void:
	outline_color = outline_color_
	fill_color = fill_color_
	outline_thickness = outline_thickness_
