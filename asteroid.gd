extends Node2D

func _ready() -> void:
	$DeathClock.start()

func setup(_position, _rotation, _scale, _z):
	z_index = _z
	global_position = _position
	rotation = _rotation
	set_scale(_scale)
	#print(global_position)

func _on_death_clock_timeout() -> void:
	queue_free()
