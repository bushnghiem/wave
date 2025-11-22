extends Camera2D
var y_speed = -500
var rotation_speed = 0.5
var zoom_alpha = 0
var zoom_speed = 0.1
var desired_zoom = Vector2(0.1, 0.1)
var spin_mode = false
var zoom_out_mode = true

func _process(delta: float) -> void:
	global_position.y += y_speed*delta
	if spin_mode:
		rotation += rotation_speed * delta
	if zoom_out_mode:
		var current_zoom = get_zoom()
		zoom_alpha += zoom_speed * delta
		set_zoom(lerp(current_zoom, desired_zoom, zoom_alpha))
