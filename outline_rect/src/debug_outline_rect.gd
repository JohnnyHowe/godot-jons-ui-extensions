@tool
class_name DebugOutlineRect
extends OutlineRect


@export var seed_offset: int = 0:
	set(value):
		if seed_offset != value:
			seed_offset = value
			_update()

@export var outline_relative_darkness: float = 0.2:
	set(value):
		if outline_relative_darkness != value:
			outline_relative_darkness = value
			_update()


func _enter_tree() -> void:
	_update()


func _update() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = get_index() + seed_offset

	outline_color = Color(
		rng.randf(),
		rng.randf(),
		rng.randf(),
	)

	outline_color = outline_color.darkened(outline_relative_darkness)
	fill_color = outline_color.lightened(outline_relative_darkness)
