extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	$CharacterBody2D.move_right = true


#refrencing the paused menu here but not sure if this is correct 
@onready var pause_screen =  $PAUSE

# this function jsut handles the input event from the user 
#so game can be called 
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"): 
		pause_screen.toggle_pause()
