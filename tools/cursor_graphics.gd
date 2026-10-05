class_name CursorGraphics
extends RefCounted
## Helpers for drawing and generating tool cursors.

const OUTLINE_COLOR := Color.BLACK
const HALO_COLOR := Color.WHITE
const HALO_WIDTH := 3.0
const OUTLINE_WIDTH := 1.0
const CROSS_ARM := 3.0


## Returns the outline of the opaque area of [param stamp], as a closed polygon
## in normalized (0 to 1) coordinates. [br]
## The convex hull is used so dithered stamps still produce a single clean shape.
static func stamp_outline(stamp: Texture2D, alpha_threshold: float = 0.1) -> PackedVector2Array:
	if stamp == null:
		return PackedVector2Array()
	var image := stamp.get_image()
	if image == null or image.is_empty():
		return PackedVector2Array()

	var corners := PackedVector2Array()
	for y in image.get_height():
		for x in image.get_width():
			if image.get_pixel(x, y).a > alpha_threshold:
				corners.append(Vector2(x, y))
				corners.append(Vector2(x + 1, y))
				corners.append(Vector2(x, y + 1))
				corners.append(Vector2(x + 1, y + 1))
	if corners.is_empty():
		return corners

	var hull := Geometry2D.convex_hull(corners)
	for i in hull.size():
		hull[i] /= Vector2(image.get_size())
	if hull[0] != hull[hull.size() - 1]:
		hull.append(hull[0])
	return hull


## Draws a brush-style preview onto [param target]. Must be called while
## [param target] is drawing. [br]
## [param outline] - Normalized outline from [method stamp_outline]. [br]
## [param center] - Center of the preview in the target's coordinates. [br]
## [param diameter] - Size of the stamp in the target's coordinates. [br]
## [param pixel_size] - Size of one screen pixel in the target's coordinates.
static func draw_stamp_preview(
	target: CanvasItem,
	outline: PackedVector2Array,
	center: Vector2,
	diameter: float,
	pixel_size: float
) -> void:
	var points := PackedVector2Array()
	for point in outline:
		points.append(center + (point - Vector2(0.5, 0.5)) * diameter)

	# A light halo under a dark line stays visible on any canvas color.
	if points.size() >= 2:
		target.draw_polyline(points, HALO_COLOR, HALO_WIDTH * pixel_size)
		target.draw_polyline(points, OUTLINE_COLOR, OUTLINE_WIDTH * pixel_size)

	# Small cross so tiny brushes still have a visible, precise center.
	draw_crosshair(target, center, pixel_size, 0.0, CROSS_ARM)


## Draws a precise crosshair onto [param target]. Must be called while
## [param target] is drawing. [br]
## [param center] - Center of the crosshair in the target's coordinates. [br]
## [param pixel_size] - Size of one screen pixel in the target's coordinates. [br]
## [param gap] - Empty space around the center, in screen pixels. [br]
## [param arm] - Length of each arm past the gap, in screen pixels.
static func draw_crosshair(
	target: CanvasItem, center: Vector2, pixel_size: float, gap: float, arm: float
) -> void:
	for direction in [Vector2.RIGHT, Vector2.DOWN]:
		for sign_value in [-1.0, 1.0]:
			var from: Vector2 = center + direction * sign_value * gap * pixel_size
			var to: Vector2 = center + direction * sign_value * (gap + arm) * pixel_size
			target.draw_line(from, to, HALO_COLOR, HALO_WIDTH * pixel_size)
			target.draw_line(from, to, OUTLINE_COLOR, OUTLINE_WIDTH * pixel_size)
