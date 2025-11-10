extends Node2D

@export var edit_spawn_parent: Node
@export var placement_area: Node

func _process(_dt):
	queue_redraw()

func _draw():
	# green dot test
	draw_circle(Vector2.ZERO, 12, Color(0, 1, 0))

	if edit_spawn_parent == null or placement_area == null:
		return

	for obj in edit_spawn_parent.get_children():
		var spr := obj.get_node_or_null("Sprite2D") as Sprite2D
		var area_cs := placement_area.get_node_or_null("CollisionShape2D") as CollisionShape2D
]		if spr == null or area_cs == null:
			continue

		if !is_sprite_fully_inside_area(spr, area_cs):
			var r := spr.get_rect()
			var base := spr.global_position
			var p0 := base + r.position
		var p1 := base + r.position + Vector2(r.size.x, 0)
			var p2 := base + r.position + r.size
			var p3 := base + r.position + Vector2(0, r.size.y)
			draw_colored_polygon([p0,p1,p2,p3], Color(1,0,0,0.25))
			draw_polyline([p0,p1,p2,p3,p0], Color(1,0,0), 2.0, true)
