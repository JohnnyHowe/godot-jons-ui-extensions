@tool
class_name ControlSizeCopier
extends Control


@export var _other: Control
@export var _size: bool = true
@export var _custom_minimum_size: bool = false


func _process(_delta):
	if not _other:
		return

	global_position = _other.global_position

	if _size:
		size = _other.size
	if _custom_minimum_size:
		custom_minimum_size = _other.size
