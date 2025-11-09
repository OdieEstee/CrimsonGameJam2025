
extends CharacterBody2D

@export var player_path: NodePath

#sword parameters

# the cooldown between each shot
@export var swing_cd: float =  2.0
# degrees to swing through
@export var swing_angle: float = 120       
# degrees per second
@export var swing_speed: float = 400
#amount of variance for the cooldown bewteen each shot
@export var swing_cd_variation: float = 0.0 

@onready var sword_area = $SwordPivot/Sword
@onready var swing_timer = $Timer
@onready var sword_pivot = $SwordPivot

var swinging = false #is sword swinging currently
var gravity : float = 600.0
var player = Node2D #used to track the position of the peseant

func _ready() -> void:
	sword_area.monitoring = false
	sword_area.visible = false
	sword_area.connect("body_entered", Callable(self, "on_sword_hit"))
	player = get_node(player_path)
	$Timer.wait_time = get_random_swing_time()
	$Timer.start()
	

func _on_timer_timeout():
	swing_sword()
	$Timer.wait_time = get_random_swing_time() #after each shot get a delay
	$Timer.start()

func get_random_swing_time() -> float:
	return randf_range(swing_cd - swing_cd_variation, swing_cd + swing_cd_variation)
	

func _physics_process(delta: float) -> void:
	# Add the gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0
	
	move_and_slide()


func swing_sword() -> void:
	if swinging:
		return
	
	swinging = true
	sword_area.visible = true
	sword_area.monitoring = true
	
	# Determine player direction
	var dir = sign(player.global_position.x - global_position.x) # 1 = right , -1  = left
	
	var pivot_offset = Vector2(60, -5) # offset to the side of the sprite that the guy is on
	sword_pivot.position = Vector2(pivot_offset.x * dir, pivot_offset.y)
	# sword_pivot.scale.x = dir  # flip sword visually if needed

	# Set start and end angles
	var start_angle = 0
	var end_angle = swing_angle
	if dir < 0:
		start_angle = 0
		end_angle = -swing_angle
	
	sword_pivot.rotation_degrees = start_angle

	# Swing procedurally
	while (dir > 0 and sword_pivot.rotation_degrees < end_angle) or (dir < 0 and sword_pivot.rotation_degrees > end_angle):
		sword_pivot.rotation_degrees += swing_speed * get_process_delta_time() * dir
		
		await get_tree().process_frame
		
	# Reset sword
	sword_pivot.rotation_degrees = 0
	sword_area.monitoring = false
	sword_area.visible = false
	swinging = false

func on_sword_hit(body: Node) -> void:
	if body == player: 
		print("Working")
	#TODO: replace with reset level
