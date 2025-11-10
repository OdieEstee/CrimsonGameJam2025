extends Node2D

@export var edit_spawn_parent: Node
@export var placement_area: Node

func _process(_dt):
	queue_redraw()

func _draw():
	# sanity dot
	draw_circle(Vector2.ZERO, 12, Color(0, 1, 0))

	if edit_spawn_parent == null or placement_area == null:
		return

	for obj in edit_spawn_parent.get_children():
		var spr := obj.get_node_or_null("Sprite2D") as Sprite2D
		var area_cs := placement_area.get_node_or_null("CollisionShape2D") as CollisionShape2D
		if spr == null or area_cs == null:
			continue

		if !is_sprite_fully_inside_area(spr, area_cs):
			print("DRAW")
			var r := spr.get_rect()
			var base := spr.global_position
			var p0 := base + r.position
			var p1 := base + r.position + Vector2(r.size.x, 0)
			var p2 := base + r.position + r.size
			var p3 := base + r.position + Vector2(0, r.size.y)
			draw_colored_polygon([p0, p1, p2, p3], Color(1, 0, 0, 0.25))
			draw_polyline([p0, p1, p2, p3, p0], Color(1, 0, 0), 2.0, true)

# ---------- helpers (local to this script) ----------
func sprite_rect_global(spr: Sprite2D) -> Rect2:
	if spr == null or spr.texture == null:
		return Rect2()
	# no rotation/scale assumption:
	var r := spr.get_rect()
	return Rect2(spr.global_position + r.position, r.size)

func area_rect_global(col: CollisionShape2D) -> Rect2:
	var rect_shape := col.shape as RectangleShape2D
	if rect_shape == null:
		return Rect2()
	var size: Vector2 = rect_shape.size
	var top_left: Vector2 = col.global_position - size * 0.5
	return Rect2(top_left, size)

func is_sprite_fully_inside_area(spr: Sprite2D, col: CollisionShape2D) -> bool:
	var srect := sprite_rect_global(spr)
	var arect := area_rect_global(col)
	return arect.encloses(srect)
