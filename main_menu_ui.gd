extends Control


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://level_1_scene.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
	

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://Credits.tscn")


func _on_level_select_pressed() -> void:
	get_tree().change_scene_to_file("res://level_selection.tscn")
