extends RigidBody2D

var move_speed : float = 100.0
var move_right : bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if move_right:
		linear_velocity.x = move_speed
	else:
		linear_velocity.x = 0
