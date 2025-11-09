extends Node2D
@onready var plank_edit_scene = preload("res://plank_edit.tscn")
@onready var plank_physics_scene = preload("res://plank_physics_1.tscn")
@onready var edit_spawn_parent = $EditSpawnParent
@onready var physics_spawn_parent = $PhysicsSpawnParent

func _on_plank_button_pressed() -> void:
	print("Spawn plank")
	var plank_edit_instance = plank_edit_scene.instantiate()
	plank_edit_instance.position = Vector2(100, -100)
	edit_spawn_parent.add_child(plank_edit_instance)


func _on_play_button_pressed() -> void:
	$CharacterBody2D.move_right = true
	for obj in edit_spawn_parent.get_children():
		obj.visible = false
		var plank_physics_instance = plank_physics_scene.instantiate()
		plank_physics_instance.position = obj.position
		plank_physics_instance.position.y += 20
		plank_physics_instance.position.x -= 1
		physics_spawn_parent.add_child(plank_physics_instance)
