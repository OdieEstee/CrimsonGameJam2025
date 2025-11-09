extends CharacterBody2D


@export var player_path: NodePath
#archer settings
# the cooldown between each shot
@export var shoot_cd: float =  1.0
#amount of variance for the cooldown bewteen each shot
@export var shoot_variantion: float = 0.0 
#arrow settings
#speed of the arrow
@export var arrow_speed: int = 1000
#texture for the arrow
#@export var arrow_texture: Texture2D

var arrow_scene: PackedScene = preload("res://arrow.tscn")

var gravity : float = 600.0
var player = Node2D #used to track the position of the peseant

func _ready() -> void:
	player = get_node(player_path)
	$Timer.wait_time = get_random_shoot_time()
	$Timer.start()

func _on_timer_timeout():
	shoot_arrow()
	$Timer.wait_time = get_random_shoot_time() #after each shot get a delay
	$Timer.start()

func get_random_shoot_time() -> float:
	return randf_range(shoot_cd - shoot_variantion, shoot_cd + shoot_variantion)

func _physics_process(delta: float) -> void:
	# Add the gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0
	
	move_and_slide()

func shoot_arrow():
	
	var arrow = arrow_scene.instantiate()
	arrow.position = $ArrowSpawn.global_position 
	arrow.rotation = (player.global_position - global_position).angle()
	var dir = (player.global_position - global_position).normalized()
	arrow.linear_velocity = dir * arrow_speed # launch the arrow
	get_tree().current_scene.add_child(arrow)
	
