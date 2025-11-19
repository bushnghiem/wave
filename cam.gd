extends Camera2D
var y_speed = -500

func _process(delta: float) -> void:
	global_position.y += y_speed*delta
