extends Node2D
var time_counter = 0
var lerp_counter = 0
var lerp_speed_multi = 5
var type = 5

func _process(delta: float) -> void:
	time_counter += delta
	if type == 0:
		global_position.x = normal_path1()
	elif type == 0.25:
		lerp_counter += delta * lerp_speed_multi
		global_position.x = lerpf(fast_path1(), normal_path2(), lerp_counter)
		if (global_position.x > normal_path2() - 10) and (global_position.x < normal_path2() + 10):
			type = 2
			lerp_counter = 0
	elif type == 0.75:
		lerp_counter += delta * lerp_speed_multi
		global_position.x = lerpf(normal_path1(), fast_path1(), lerp_counter)
		if (global_position.x > fast_path1() - 10) and (global_position.x < fast_path1() + 10):
			type = 1
			lerp_counter = 0
	elif type == 1:
		global_position.x = fast_path1()
	elif type == 2:
		global_position.x = normal_path2()
	elif type == 3:
		global_position.x = fast_path2()
	else:
		global_position.x = 0

func normal_path1():
	return sin(PI * time_counter + PI/2) * 500

func fast_path1():
	return sin(2 * PI * time_counter + PI/2) * 250

func normal_path2():
	return sin(PI * time_counter + 3 * PI / 2) * 500

func fast_path2():
	return sin(2 * PI * time_counter + 3 * PI / 2) * 250

func short_swap():
	type = 0.75

func normal_swap():
	type = 0.25

func mistake():
	$Sprite2D.modulate = Color(1, 0, 0)
	$ColorReset.start()

func perfect():
	$Sprite2D.modulate = Color(0, 1, 0)
	$ColorReset.start()

func good():
	$Sprite2D.modulate = Color(1, 1, 0)
	$ColorReset.start()

func _on_color_reset_timeout() -> void:
	$Sprite2D.modulate = Color(1, 1, 1)
