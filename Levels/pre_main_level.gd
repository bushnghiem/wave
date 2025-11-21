extends Node2D


func _on_level_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Levels/game.tscn")
