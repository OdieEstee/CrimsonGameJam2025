# PlacementArea.gd
extends Area2D

@onready var shape_node : CollisionShape2D = $CollisionShape2D

func _process(delta):
	queue_redraw()

func _draw():
	var parent_node = get_parent()
	var player_node = parent_node.get_node("CharacterBody2D")
	if shape_node.shape is RectangleShape2D and not player_node.move_right:
		var rect_size = shape_node.shape.size
		var offset = shape_node.position
		var rect = Rect2(offset - rect_size / 2, rect_size)
		draw_rect(rect, Color(0, 1, 0, 0.05), true)
		draw_rect(rect, Color(0, 1, 0, .3), false, 2)

func get_area_rect() -> Rect2:
	if shape_node.shape is RectangleShape2D:
		var rect_size = shape_node.shape.size
		var offset = shape_node.position
		# Convert to global coordinates
		return Rect2(global_position + offset - rect_size / 2, rect_size)
	return Rect2()
