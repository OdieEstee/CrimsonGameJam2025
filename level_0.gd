extends Node2D
@onready var plank_scene = preload("res://plank.tscn")
@onready var spawn_parent = $SpawnParent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	$CharacterBody2D.move_right = true
	for object in spawn_parent.get_children():
		object.freeze = false


func _on_object_button_pressed() -> void:
	var plank_instance = plank_scene.instantiate()
	plank_instance.freeze = true
	plank_instance.position = Vector2(0, 0)
	spawn_parent.add_child(plank_instance)
