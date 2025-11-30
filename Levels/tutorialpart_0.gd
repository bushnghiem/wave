extends Node2D

func _ready() -> void:
	$AnimationPlayer.play("unfade")

func _on_particle_tutorial_left() -> void:
	$CanvasLayer/Instruction.set_position(Vector2(46, 236))
	$CanvasLayer/Instruction.text = "Press A Now"
	$CanvasLayer/Instruction.visible = true


func _on_tutorial_rhythm_pressed_correct() -> void:
	$CanvasLayer/Instruction.visible = false


func _on_particle_tutorial_right() -> void:
	$CanvasLayer/Instruction.set_position(Vector2(1000, 236))
	$CanvasLayer/Instruction.text = "Press D Now"
	$CanvasLayer/Instruction.visible = true


func _on_tutorial_rhythm_finished() -> void:
	$CanvasLayer/FinalMessage.visible = true
