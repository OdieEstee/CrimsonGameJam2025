extends Node2D
@onready var plank_edit_scene = preload("res://plank_edit.tscn")
@onready var plank_physics_scene = preload("res://plank_physics_1.tscn")
@onready var edit_spawn_parent = $EditSpawnParent
@onready var physics_spawn_parent = $PhysicsSpawnParent
@onready var label = $MaterialsLabel
@onready var placement_area = $PlacementArea

var starting_player_pos : Vector2
var materials : int = 100
var plank_cost : int = 100
var valid_placement : bool = true

func _process(delta):
	label.text = "Materials: " + str(materials)
	
func _ready():
	starting_player_pos = $CharacterBody2D.position

func _on_plank_button_pressed() -> void:
	if materials >= plank_cost:
		materials -= plank_cost
		print("Spawn plank")
		var plank_edit_instance = plank_edit_scene.instantiate()
		plank_edit_instance.position = Vector2(200, -200)
		edit_spawn_parent.add_child(plank_edit_instance)

func _on_play_button_pressed() -> void:
	valid_placement = true
	for obj in edit_spawn_parent.get_children():
		var obj_sprite = obj.get_node_or_null("Sprite2D") as Sprite2D
		var placement_area_collision = placement_area.get_node_or_null("CollisionShape2D") as CollisionShape2D
		if not is_sprite_fully_inside_area(obj_sprite, placement_area_collision):
			valid_placement = false
	if valid_placement:
		$CharacterBody2D.move_right = true
		$Label.visible = false
		$MaterialsLabel.visible = false
		$PlankButton.visible = false
		$ResetButton.visible = true
		$PlayButton.visible = false
		for obj in edit_spawn_parent.get_children():
			obj.visible = false
			var plank_physics_instance = plank_physics_scene.instantiate()
			plank_physics_instance.position = obj.position
			plank_physics_instance.position.y += 20
			plank_physics_instance.position.x -= 1
			physics_spawn_parent.add_child(plank_physics_instance)

# --- helpers ---
func sprite_rect_global(spr: Sprite2D) -> Rect2:
	if spr == null or spr.texture == null:
		return Rect2()
	var r := spr.get_rect()  # respects centered/offset/region/frame
	return Rect2(spr.global_position + r.position, r.size)

func area_rect_global(col: CollisionShape2D) -> Rect2:
	# Assumes RectangleShape2D and no rotation/scale
	var rect_shape := col.shape as RectangleShape2D
	if rect_shape == null:
		return Rect2()
	var size: Vector2 = rect_shape.size          # Godot 4 uses `size`
	var top_left: Vector2 = col.global_position - size * 0.5
	return Rect2(top_left, size)

# --- check containment: area fully contains the sprite rect ---
func is_sprite_fully_inside_area(spr: Sprite2D, col: CollisionShape2D) -> bool:
	var srect := sprite_rect_global(spr)
	var arect := area_rect_global(col)
	return arect.encloses(srect)   # true only if srect is entirely inside arect

func _on_reset_button_pressed() -> void:
	$ResetButton.visible = false
	$PlayButton.visible = true
	$Label.visible = true
	$MaterialsLabel.visible = true
	$PlankButton.visible = true
	for obj in physics_spawn_parent.get_children():
		obj.queue_free()
	for obj in edit_spawn_parent.get_children():
		obj.visible = true
	$CharacterBody2D.move_right = false
	$CharacterBody2D.position = starting_player_pos

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			for obj in edit_spawn_parent.get_children():
				if obj.mouse_over:
					obj.queue_free()
					if obj.type == "Plank":
						materials += plank_cost
