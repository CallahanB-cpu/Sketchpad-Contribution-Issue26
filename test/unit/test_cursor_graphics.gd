extends GutTest

const SQUARE := "res://assets/brush_templates/big_square.png"
const CIRCLE := "res://assets/brush_templates/big_circle.png"
const DITHERED := "res://assets/brush_templates/big_semi_square.png"


func _bounds(points: PackedVector2Array) -> Rect2:
	var rect := Rect2(points[0], Vector2.ZERO)
	for point in points:
		rect = rect.expand(point)
	return rect


func test_outline_of_null_stamp_is_empty():
	assert_eq(CursorGraphics.stamp_outline(null).size(), 0)


func test_outline_of_square_covers_unit_square():
	var outline := CursorGraphics.stamp_outline(load(SQUARE))
	assert_eq(_bounds(outline), Rect2(0, 0, 1, 1))
	assert_eq(outline[0], outline[outline.size() - 1], "Outline should be closed")


func test_outline_of_circle_has_cut_corners():
	var outline := CursorGraphics.stamp_outline(load(CIRCLE))
	assert_eq(_bounds(outline), Rect2(0, 0, 1, 1))
	assert_false(outline.has(Vector2(0, 0)), "Circle should not touch the square's corner")


func test_outline_of_dithered_stamp_is_one_shape():
	var outline := CursorGraphics.stamp_outline(load(DITHERED))
	assert_eq(_bounds(outline), Rect2(0, 0, 1, 1))
	assert_lt(outline.size(), 10, "Dithered stamp should reduce to a simple hull")


func test_tools_keep_system_cursor_by_default():
	assert_false(Tool.new().hides_system_cursor())
	assert_false(Dragger.new().hides_system_cursor())


func test_brush_eraser_and_bucket_hide_system_cursor():
	assert_true(Brush.new().hides_system_cursor())
	assert_true(Eraser.new().hides_system_cursor())
	assert_true(PaintBucket.new().hides_system_cursor())


func test_overlay_hides_cursor_only_while_hovering_a_hiding_tool():
	var overlay := CursorOverlay.new()
	add_child_autofree(overlay)
	overlay.tool = PaintBucket.new()
	assert_false(overlay.system_cursor_hidden, "Not hovering yet")
	overlay.set_hovered(true)
	assert_true(overlay.system_cursor_hidden)
	overlay.set_hovered(false)
	assert_false(overlay.system_cursor_hidden)


func test_overlay_keeps_cursor_for_dragger():
	var overlay := CursorOverlay.new()
	add_child_autofree(overlay)
	overlay.tool = Dragger.new()
	overlay.set_hovered(true)
	assert_false(overlay.system_cursor_hidden)
	overlay.set_hovered(false)


func test_overlay_restores_cursor_when_tool_switches_to_dragger():
	var overlay := CursorOverlay.new()
	add_child_autofree(overlay)
	overlay.tool = Brush.new()
	overlay.set_hovered(true)
	assert_true(overlay.system_cursor_hidden)
	overlay.tool = Dragger.new()
	assert_false(overlay.system_cursor_hidden)
	overlay.set_hovered(false)


func test_overlay_hover_toggles_without_tool():
	var overlay := CursorOverlay.new()
	add_child_autofree(overlay)
	overlay.set_hovered(true)
	overlay.set_hovered(false)
	pass_test("No tool set should not error")
