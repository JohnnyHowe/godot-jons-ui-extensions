@tool
extends OutlineRect


var _rng : RandomNumberGenerator

func _enter_tree() -> void:
	_rng = RandomNumberGenerator.new()
	_rng.seed = get_index()

	fill_color = Color(
		_rng.randf(),
		_rng.randf(),
		_rng.randf(),
		0.5
	)
