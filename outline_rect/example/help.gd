@tool
extends RichTextLabel


@export var wobble_period: float = 1
@export var wobble_degrees: float = 30


func _process(_delta: float) -> void:
	var wobble_normalized := sin(2 * PI * Time.get_ticks_msec() * 0.001 / wobble_period)
	rotation_degrees = wobble_normalized * wobble_degrees
