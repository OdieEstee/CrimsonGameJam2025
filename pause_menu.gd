extends Control


@onready var panel := self
@onready var resume_btn := $Panel/ResumeButton      # <-- update paths to match your node names
@onready var quit_btn   := $Panel/QuitButton        # <-- e.g. $VBox/Resume, $VBox/Quit, etc.

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS   # still runs while paused
	panel.visible = false                     # hidden at start
	# Connect buttons (or wire in the editor):
	if is_instance_valid(resume_btn):
		resume_btn.pressed.connect(_on_resume_pressed)
	if is_instance_valid(quit_btn):
		quit_btn.pressed.connect(_on_quit_pressed)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):      # Esc toggles pause
		toggle_pause()

func toggle_pause() -> void:
	if get_tree().paused:
		unpause_game()
	else:
		pause_game()

func pause_game() -> void:
	get_tree().paused = true
	panel.visible = true

func unpause_game() -> void:
	get_tree().paused = false
	panel.visible = false

# linked up the resume button pressed so you can go 
func _on_resume_pressed() -> void:
	unpause_game()

func _on_quit_pressed() -> void:
	get_tree().quit()  # quit the game entirely
