@tool
extends RichTextLabel

@export var time_color := Color.WHITE
@export var signal_color := Color.WHITE
@export var value_color := Color.WHITE


func _enter_tree() -> void:
	text = ""


func _on_int_edit_number_changed(number: int) -> void:
	text += " ".join([
		"\n",
		_color_text("[%s]" % Time.get_time_string_from_system(), time_color),
		_color_text(" number_changed: ", signal_color),
		_color_text(str(number), value_color)
	])


func _color_text(s: String, color: Color) -> String:
	return "[color=#%s]%s[/color]" % [color.to_html(), s]
