@tool
extends CanvasLayer

class DrawerNode extends Control:
	var _target: LayoutEaser

	func _init(target: LayoutEaser) -> void:
		_target = target
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		mouse_filter = Control.MOUSE_FILTER_IGNORE


	func _process(_delta: float) -> void:
		queue_redraw()


	func _draw() -> void:
		if not visible:
			return
		if _target == null:
			return

		if _target._collapsed_layout:
			_target._collapsed_layout_debug_draw_params.rect = _target._collapsed_layout.get_global_rect()
			DashedOutlineRect.Drawer.draw(self , _target._collapsed_layout_debug_draw_params)
		if _target._expanded_layout:
			_target._expanded_layout_debug_draw_params.rect = _target._expanded_layout.get_global_rect()
			DashedOutlineRect.Drawer.draw(self , _target._expanded_layout_debug_draw_params)
		if _target._subject:
			_target._subject_debug_draw_params.rect = _target._subject.get_global_rect()
			DashedOutlineRect.Drawer.draw(self , _target._subject_debug_draw_params)


func _init(target: LayoutEaser) -> void:
	add_child(DrawerNode.new(target))
