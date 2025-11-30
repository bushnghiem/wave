extends Node2D
var blackout = false

func _unhandled_input(event):
	if Input.is_action_pressed("left"):
		if $Label.visible:
			left_button()
	if Input.is_action_pressed("right"):
		if $Label2.visible:
			right_button()

func left_button():
	_on_button_pressed()

func right_button():
	_on_button_2_pressed()

func _ready() -> void:
	$AnimationPlayer2.play("satellitespin")
	$AnimationPlayer.play('title')
	$AudioStreamPlayer.play()

func _on_button_pressed() -> void:
	if !blackout:
		$Buttonfx.play()
		$AnimationPlayer4.play("volume")
		$AnimationPlayer3.play("blackout")
		get_tree().create_timer(1.5).timeout.connect(func():
			get_tree().change_scene_to_file("res://Levels/game.tscn")
			);
		blackout = true


func _on_button_2_pressed() -> void:
	if !blackout:
		$Buttonfx.play()
		$AnimationPlayer4.play("volume")
		$AnimationPlayer3.play("blackout")
		get_tree().create_timer(1.5).timeout.connect(func():
			get_tree().change_scene_to_file("res://Levels/tutorialpart_0.tscn")
			);
		blackout = true


func _on_audio_stream_player_finished() -> void:
	$AudioStreamPlayer2.play()


func _on_audio_stream_player_2_finished() -> void:
	$AudioStreamPlayer2.play()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$AnimationPlayer.play("rocket")
