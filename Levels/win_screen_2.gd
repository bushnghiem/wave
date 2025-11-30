extends Node2D
var counter = 0
var resetable = false
func _ready() -> void:
	$HappyMusic.play()
	$Timer.start()

func _unhandled_input(event):
	if Input.is_action_pressed("left"):
		left_button()
	if Input.is_action_pressed("right"):
		right_button()
	if Input.is_action_pressed("reset"):
		if resetable:
			reset_button()
	if Input.is_action_pressed("quit"):
			quit_button()

func left_button():
	pass

func right_button():
	pass

func reset_button():
	get_tree().change_scene_to_file("res://Levels/title_screen.tscn")

func quit_button():
	get_tree().change_scene_to_file("res://Levels/title_screen.tscn")

func _on_timer_timeout() -> void:
	counter += 1
	if counter == 1:
		$Sprite2D.visible = true
		$Sprite2D2.visible = true
	elif counter == 3:
		$GoodWinText.visible = true
	elif counter == 4:
		$GoodJob.visible = true
		resetable = true
