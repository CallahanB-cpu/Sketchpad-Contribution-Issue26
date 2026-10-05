class_name CursorOverlay
extends Node2D
## Draws the active tool's cursor preview above the canvas, and swaps the
## system cursor while the pointer is over the canvas.

var tool: Tool:
	set(value):
		tool = value
		_apply_system_cursor()
		queue_redraw()

## Whether the system cursor is currently hidden by this overlay.
var system_cursor_hidden := false

var _hovered := false


func _ready() -> void:
	set_process(false)


func _process(_delta: float) -> void:
	# Keeps the preview following the pointer and matching tool settings.
	queue_redraw()


func _draw() -> void:
	if not _hovered or tool == null:
		return
	var scale_factor := get_global_transform_with_canvas().get_scale().x
	var pixel_size := 1.0 / maxf(scale_factor, 0.001)
	tool.draw_cursor_preview(self, get_local_mouse_position(), pixel_size)


func _exit_tree() -> void:
	_hovered = false
	_apply_system_cursor()


## Call when the pointer enters or leaves the canvas.
func set_hovered(value: bool) -> void:
	if _hovered == value:
		return
	_hovered = value
	set_process(value)
	_apply_system_cursor()
	queue_redraw()


func _apply_system_cursor() -> void:
	system_cursor_hidden = _hovered and tool != null and tool.hides_system_cursor()
	Input.mouse_mode = (
		Input.MOUSE_MODE_HIDDEN if system_cursor_hidden else Input.MOUSE_MODE_VISIBLE
	)
