extends CharacterBody2D

var move_speed : float = 200.0
var gravity : float = 600.0
var move_right : bool = false;

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0
	
	if move_right:
		velocity.x = move_speed
	
	move_and_slide()
