extends Node2D

func _ready() -> void:
	#get_tree().create_timer(1).timeout.connect(func():
	$Song.play()
	#);
