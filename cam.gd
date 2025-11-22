extends Camera2D
var y_speed = -500
var rotation_speed = 0.5
var zoom_alpha = 0
var zoom_speed = 0.1
var normal_zoom = Vector2(1, 1)
var zoomed_out = Vector2(0.1, 0.1)
var spin_mode = false
var zoom_out_mode = false
var zoom_in_mode = false

func _process(delta: float) -> void:
	global_position.y += y_speed*delta
	if spin_mode:
		rotation += rotation_speed * delta
	if zoom_out_mode and zoom_alpha < 1:
		zoom_alpha += zoom_speed * delta
		set_zoom(lerp(normal_zoom, zoomed_out, zoom_alpha))
	elif zoom_out_mode and zoom_alpha >= 1:
		zoom_out_mode = false
		zoom_alpha = 0
		zoom_in_mode = true
	if zoom_in_mode:
		zoom_alpha += zoom_speed * delta
		set_zoom(lerp(zoomed_out, normal_zoom, zoom_alpha))
	
