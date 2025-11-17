extends Node2D

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
