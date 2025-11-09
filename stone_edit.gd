extends CharacterBody2D

var grabbed: bool = false
var mouse_over: bool = false

var type : String = "Stone"

func _input(event):
	if event is InputEventMouseButton and mouse_over:
		if event.button_index == MOUSE_BUTTON_LEFT:
			grabbed = event.pressed

func _process(delta):
	if grabbed:
		global_position = get_global_mouse_position()
