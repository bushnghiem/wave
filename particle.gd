extends Node2D
var time_counter1 = 0
var time_counter2 = 0
var time_counter3 = 0
var time_counter4 = 0
var lerp_counter = 0
var lerp_speed_multi = 0.5
var type = 0
var y_speed = -500

func _process(delta: float) -> void:
	#print("position: " + str(global_position.x) + " time: " + str(time_counter4))
	#print(lerp_counter)
	global_position.y += y_speed * delta
	if type == 0:
		time_counter1 += delta
		global_position.x = normal_path1()
	elif type == 0.25:
		time_counter1 += delta
		#swapping from fast to normal left
		lerp_counter += delta * lerp_speed_multi
		global_position.x = lerpf(global_position.x, normal_path1(), lerp_counter)
		if (global_position.x > normal_path1() - 10) and (global_position.x < normal_path1() + 10):
			#print(str(global_position.x) + " is close enough to " + str(normal_path1()))
			type = 0
			lerp_counter = 0
	elif type == 0.75:
		time_counter3 += delta
		#swapping from fast to normal right
		lerp_counter += delta * lerp_speed_multi
		global_position.x = lerpf(global_position.x, normal_path2(), lerp_counter)
		if (global_position.x > normal_path2() - 10) and (global_position.x < normal_path2() + 10):
			#print(str(global_position.x) + " is close enough to " + str(fast_path1()))
			type = 2
			lerp_counter = 0
	elif type == 1:
		time_counter2 += delta
		global_position.x = fast_path1()
	elif type == 1.25:
		time_counter2 += delta
		#swapping from normal to fast left
		lerp_counter += delta * lerp_speed_multi
		global_position.x = lerpf(global_position.x, fast_path1(), lerp_counter)
		if (global_position.x > fast_path1() - 10) and (global_position.x < fast_path1() + 10):
			#print(str(global_position.x) + " is close enough to " + str(normal_path1()))
			type = 1
			lerp_counter = 0
	elif type == 1.75:
		time_counter4 += delta
		#swapping from normal to fast right
		lerp_counter += delta * lerp_speed_multi
		global_position.x = lerpf(global_position.x, fast_path2(), lerp_counter)
		if (global_position.x > fast_path2() - 10) and (global_position.x < fast_path2() + 10):
			#print(str(global_position.x) + " is close enough to " + str(fast_path1()))
			type = 3
			lerp_counter = 0
	elif type == 2:
		time_counter3 += delta
		global_position.x = normal_path2()
	elif type == 3:
		time_counter4 += delta
		global_position.x = fast_path2()
	else:
		global_position.x = 0

func normal_path1():
	#Starts left at 1 note per second
	return sin(PI * time_counter1 + PI/2) * 500

func fast_path1():
	#Starts left at 1 note per half second or 2 per second
	return sin(2 * PI * time_counter2 + PI/2) * 250

func normal_path2():
	#Starts right at 1 note per second
	return sin(PI * time_counter3 + 3 * PI / 2) * 500

func fast_path2():
	#Starts right at 1 note per half second or 2 per second
	return sin(2 * PI * time_counter4 + 3 * PI / 2) * 250

func swap_to_norm_left():
	time_counter1 = 0
	type = 0.25
	print("normal left now")

func swap_to_norm_right():
	time_counter3 = 0
	type = 0.75
	print("normal right now")

func swap_to_fast_left():
	time_counter2 = 0
	type = 1.25
	print("fast left now")

func swap_to_fast_right():
	time_counter4 = 0
	type = 1.75
	print("fast right now")


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
