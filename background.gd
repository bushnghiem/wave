extends Node2D
var y_speed = -490
var zoom_speed = 0.1
var zoom_alpha = 0
var normal_scale = Vector2(0.25, 0.25)
var scaled_out = Vector2(5, 5)
var spin_mode = false
var zoom_out_mode = false

func _process(delta: float) -> void:
	global_position.y += y_speed*delta
	if zoom_out_mode and zoom_alpha < 1:
		print(zoom_alpha)
		zoom_alpha += zoom_speed * delta
		scale = lerp(normal_scale, scaled_out, zoom_alpha)
