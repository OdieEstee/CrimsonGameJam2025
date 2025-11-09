extends Area2D

@export_file("*.tscn") var next_scene
@onready var _animated_sprite = $AnimatedSprite2D

var triggered : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_animated_sprite.play("idle")
	_animated_sprite.stop()

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and not triggered:
		triggered = true
		body.move_right = false
		var parent_node = get_parent()
		var placement_node = parent_node.get_node_or_null("PlacementArea") as Area2D
		placement_node.visible = false
		_animated_sprite.play("open")
		while _animated_sprite.frame < _animated_sprite.sprite_frames.get_frame_count(_animated_sprite.animation) - 1:
			await get_tree().process_frame
		get_tree().change_scene_to_file(next_scene)
