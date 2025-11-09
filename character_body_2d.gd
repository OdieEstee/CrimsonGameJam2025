extends CharacterBody2D

@export var move_speed : float = 40.0
@export var gravity : float = 600.0
@export var move_right : bool = false

# Step parameters
@export var step_height : float = 10.0           # how high you can step (pixels)
@export var step_forward_check : float = 6.0    # how far forward to test (pixels)
@export var step_margin : float = 0.01          # small margin for intersect_shape queries

@onready var _animated_sprite = $AnimatedSprite2D
@onready var _col_shape_node = $CollisionShape2D   # adapt path if your CollisionShape2D is elsewhere

func _physics_process(delta):
	# gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	# horizontal input/animation (keep logic same)
	if move_right:
		velocity.x = move_speed
		_animated_sprite.play("Walk")
		_try_step_up(Vector2(1, 0))
	else:
		velocity.x = 0
		_animated_sprite.play("Idle")

	# finally let CharacterBody2D handle motion
	move_and_slide()

# --- Step-up using shape intersection tests (works with RigidBody2D) ---
func _try_step_up(direction: Vector2) -> void:
	if not is_instance_valid(_col_shape_node) or _col_shape_node.shape == null:
		return

	var space_state = get_world_2d().direct_space_state
	var base_transform : Transform2D = _col_shape_node.global_transform
	var forward_offset = direction.normalized() * step_forward_check

	var params = PhysicsShapeQueryParameters2D.new()
	params.shape = _col_shape_node.shape
	params.exclude = [self]
	params.margin = step_margin

	# Check if we are blocked when moving forward
	params.transform = base_transform.translated(forward_offset)
	var lower_hits = space_state.intersect_shape(params, 1)

	if lower_hits.size() == 0:
		return  # no obstacle directly ahead, no need to step

	# Try progressively higher positions until free, up to max step_height
	var step_found := false
	var needed_step := 0.0
	for i in range(int(step_height)):
		var offset_y = float(i + 1) * -1.0  # move upward by 1px each iteration
		params.transform = base_transform.translated(forward_offset + Vector2(0, offset_y))
		var hits = space_state.intersect_shape(params, 1)
		if hits.size() == 0:
			step_found = true
			needed_step = i + 1
			break

	# If a valid step found, move up only that much
	if step_found:
		global_position.y -= needed_step
