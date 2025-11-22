extends Camera2D
var y_speed = -500
var rotation_speed = 0.5
var zoom_speed = 0.1
var spin_mode = true
var zoom_out_mode = true

func _process(delta: float) -> void:
	global_position.y += y_speed*delta
	if spin_mode:
		rotation += rotation_speed * delta
	if zoom_out_mode:
		var current_zoom = get_zoom()
		current_zoom = current_zoom - Vector2(zoom_speed*delta, zoom_speed*delta)
		set_zoom(current_zoom)
