extends Area2D

func _ready():
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))

func _on_mouse_entered():
	get_parent().mouse_over = true

func _on_mouse_exited():
	get_parent().mouse_over = false
