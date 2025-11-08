extends RigidBody2D

var grabbed: bool = false

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event):
	if event is InputEventMouseButton and freeze:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if get_global_mouse_position().distance_to(global_position) < 32:
					grabbed = true
			else:
				grabbed = false

func _process(delta):
	if grabbed:
		global_position = lerp(global_position, get_global_mouse_position(), 0.4)
