extends Node2D

@export var tutorial_part = 2


func _on_tutorial_time_timeout() -> void:
	get_tree().change_scene_to_file("res://Levels/tutorialpart" + str(tutorial_part) + ".tscn")
