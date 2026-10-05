class_name Tool
extends Resource

signal settings_changed

@export var name: String = "Base"
@export var icon: Texture2D = PlaceholderTexture2D.new()
@export var handler: PackedScene
@export var handler_bar: PackedScene


## Triggers when the pointer is pressed down on the canvas. [br]
## [param _position] - Position of pointer. [br]
## [param _canvas] - The active canvas node.
func on_pointer_down(_position: Vector2, _canvas: Canvas) -> void:
	pass


## Triggers when the pointer is released from the canvas. [br]
## [param _position] - Position of pointer. [br]
## [param _canvas] - The active canvas node.
func on_pointer_up(_position: Vector2, _canvas: Canvas) -> void:
	pass


## Triggers when the pointer is moved around the canvas. [br]
## [param _position] - Position of pointer. [br]
## [param _canvas] - The active canvas node.
func on_pointer_move(_position: Vector2, _canvas: Canvas) -> void:
	pass


## Whether the system cursor is hidden over the canvas. Tools that return
## [code]true[/code] should draw their own cursor in [method draw_cursor_preview].
func hides_system_cursor() -> bool:
	return false


## Draws a preview of the tool at the pointer. Called from the cursor overlay's
## draw step, so [param _target] can be drawn on directly. [br]
## [param _position] - Position of pointer in canvas coordinates. [br]
## [param _pixel_size] - Size of one screen pixel in canvas coordinates.
func draw_cursor_preview(_target: CanvasItem, _position: Vector2, _pixel_size: float) -> void:
	pass
