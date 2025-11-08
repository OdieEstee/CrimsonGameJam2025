extends Area2D

@export_file("*.tscn") var next_scene

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		get_tree().change_scene_to_file(next_scene)
