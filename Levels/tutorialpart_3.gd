extends Node2D
var alpha = 0
var alpha_speed = 0.5
var default_modulate = 0
var desired_modulate = 1
var blackout = false

func _ready() -> void:
	print("alternating normals and shorts, cmon you got this")

func _process(delta: float) -> void:
	if blackout:
		alpha += delta * alpha_speed
		var new_mod = lerpf(default_modulate, desired_modulate, alpha)
		$CanvasLayer/Blackout.self_modulate.a = new_mod

func _on_rhythm_end_of_tutorial() -> void:
	print("winner")
	$CanvasLayer/Label.visible = true
	blackout = true
