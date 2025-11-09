extends RigidBody2D


func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 1  # how many collisions to report
	connect("body_entered", Callable(self, "_on_arrow_hit"))

func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free() #if the arrow leaves the screen remove it 

func _on_arrow_hit(body):
	# TODO: add logic here to #if body.group == player:
	# TODO: if arrow hits Player reset
	queue_free()  # remove it from the scene
