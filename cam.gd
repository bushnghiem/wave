extends Camera2D
var y_speed = -500
var rotation_speed = 0.1
var zoom_alpha = 0
var rotation_alpha = 0
var normal_rotation = 0
var desired_rotation = 2 * PI
var desired_rotation2 = -2 * PI
var zoom_speed = 0.2
var normal_zoom = Vector2(1, 1)
var zoomed_out = Vector2(0.1, 0.1)
var ccw_spin_mode = false
var cw_spin_mode2 = false
var zoom_out_mode = false
var zoom_in_mode = false
var spin_count = 0
var spin_limit = 2

func _process(delta: float) -> void:
	global_position.y += y_speed*delta
	if ccw_spin_mode and rotation_alpha < 1:
		rotation_alpha += rotation_speed * delta
		rotation = lerpf(normal_rotation, desired_rotation, rotation_alpha)
	elif ccw_spin_mode and rotation_alpha >= 1 and spin_count >= spin_limit:
		print("equal to spin limit " + str(spin_limit) + " and spin count is " + str(spin_count))
		ccw_spin_mode = false
		rotation_alpha = 0
		rotation = 0
	elif ccw_spin_mode and rotation_alpha >= 1 and spin_count < spin_limit:
		print("spin count is " + str(spin_count))
		spin_count += 1
		rotation_alpha = 0
		rotation = 0
	if cw_spin_mode2 and rotation_alpha < 1:
		rotation_alpha += rotation_speed * delta
		rotation = lerpf(normal_rotation, desired_rotation2, rotation_alpha)
	elif cw_spin_mode2 and rotation_alpha >= 1:
		cw_spin_mode2 = false
		rotation_alpha = 0
		rotation = 0
	if zoom_out_mode and zoom_alpha < 1:
		zoom_alpha += zoom_speed * delta
		set_zoom(lerp(normal_zoom, zoomed_out, zoom_alpha))
	elif zoom_out_mode and zoom_alpha >= 1:
		zoom_out_mode = false
		zoom_alpha = 0
	if zoom_in_mode:
		zoom_alpha += zoom_speed * delta
		set_zoom(lerp(zoomed_out, normal_zoom, zoom_alpha))
	
