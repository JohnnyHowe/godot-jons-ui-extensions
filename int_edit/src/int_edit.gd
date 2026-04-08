@tool
class_name IntEdit
extends Control

signal number_changed(number: int)

@export var value: int:
	get:
		return _value
	set(new_value):
		if _value != new_value:
			_value = new_value
			if _line_edit.text != str(value):
				_line_edit.text = str(_value)
			number_changed.emit(_value)

var _value: int = 0

var _margin_container: MarginContainer

var _line_edit: LineEdit:
	get:
		if not _line_edit:
			_create_internal_ui()
		return _line_edit


func _enter_tree() -> void:
	_text_edited()


func _create_internal_ui() -> void:
	_margin_container = MarginContainer.new()
	_margin_container.add_theme_constant_override("margin_left", 0)
	_margin_container.add_theme_constant_override("margin_top", 0)
	_margin_container.add_theme_constant_override("margin_right", 0)
	_margin_container.add_theme_constant_override("margin_bottom", 0)
	add_child(_margin_container, false, Node.INTERNAL_MODE_FRONT)

	_line_edit = LineEdit.new()
	_margin_container.add_child(_line_edit, false, Node.INTERNAL_MODE_FRONT)

	_line_edit.text_changed.connect(func(_text): _text_edited())


func _process(_delta: float) -> void:
	if _margin_container:
		custom_minimum_size = _margin_container.size

	if _line_edit:
		if Engine.is_editor_hint():
			_line_edit.text = str(value)


func _text_edited() -> void:
	var regex := RegEx.new()
	regex.compile("[^0-9]") # anything NOT 0–9
	var edited = regex.sub(_line_edit.text, "", true)

	if edited != _line_edit.text:
		_line_edit.text = edited

	if _line_edit.text.is_valid_int():
		value = int(_line_edit.text)
	

func _exit_tree():
	if _line_edit: _line_edit.queue_free()
	if _margin_container: _margin_container.queue_free()
