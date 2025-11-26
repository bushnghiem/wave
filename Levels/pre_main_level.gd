extends Node2D
var alpha = 0
var alpha_speed = 0.8
var default_modulate = 0
var desired_modulate = 1

func _process(delta: float) -> void:
	#print(alpha)
	alpha += delta * alpha_speed
	var new_mod = lerpf(default_modulate, desired_modulate, alpha)
	$Blackout.self_modulate.a = new_mod

func _on_level_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Levels/game.tscn")
