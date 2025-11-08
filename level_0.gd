extends Node2D
@onready var plank_scene = preload("res://plank_build.tscn")
@onready var plank_physics_scene = preload("res://plank_physics.tscn")
@onready var spawn_parent = $SpawnParent
@onready var physics_spawn_parent = $PhysicsSpawnParent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	$CharacterBody2D.move_right = true
	for obj in spawn_parent.get_children():
		obj.visible = false
		var plank_physics_instance = plank_physics_scene.instantiate()
		plank_physics_instance.position = obj.position
		physics_spawn_parent.add_child(plank_physics_instance)


func _on_object_button_pressed() -> void:
	var plank_instance = plank_scene.instantiate()
	plank_instance.position = Vector2(0, 0)
	spawn_parent.add_child(plank_instance)
