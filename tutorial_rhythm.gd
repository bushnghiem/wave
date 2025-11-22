extends Node2D

signal pressed_correct
signal pressed_incorrect
signal finished

var press_left_now = false
var press_right_now = false
var correct_counter = 0

func _unhandled_input(event):
	if Input.is_action_pressed("left"):
		left_button()
	if Input.is_action_pressed("right"):
		right_button()
	if Input.is_action_pressed("reset"):
		reset_button()


func left_button():
	if get_tree().paused and press_left_now:
		get_tree().paused = false
		press_left_now = false
		pressed_correct.emit()
		correct_counter += 1
		if correct_counter == 6:
			finished.emit()
	elif !press_left_now:
		pressed_incorrect.emit()

func right_button():
	if get_tree().paused and press_right_now:
		get_tree().paused = false
		press_right_now = false
		pressed_correct.emit()
		correct_counter += 1
		if correct_counter == 6:
			finished.emit()
	elif !press_right_now:
		pressed_incorrect.emit()

func reset_button():
	if get_tree().paused:
		get_tree().paused = false
	get_tree().change_scene_to_file("res://Levels/pre_tutorial_1.tscn")

func _on_particle_tutorial_left() -> void:
	press_left_now = true


func _on_particle_tutorial_right() -> void:
	press_right_now = true
