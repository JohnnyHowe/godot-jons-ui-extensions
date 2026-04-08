@tool
extends CustomContainerBase


@export var seed: int = 0


func arrange_children(visible_children: Array[Control]) -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed

	for child in visible_children:
		_arrange_child(child, rng)


func _arrange_child(child: Control, rng: RandomNumberGenerator) -> void:
	var new_size := Vector2(
		rng.randf() * (size.x - child.custom_minimum_size.x),
		rng.randf() * (size.y - child.custom_minimum_size.y),
	)

	var new_position := Vector2(
		rng.randf() * (size.x - new_size.x),
		rng.randf() * (size.y - new_size.y),
	)

	child.position = new_position
	child.size = new_size
