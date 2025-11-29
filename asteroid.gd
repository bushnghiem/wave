extends Node2D
var can_die = false

func _ready() -> void:
	$DeathClock.start()
	#rocket()

func setup(_position, _rotation, _scale, _z):
	z_index = _z
	global_position = _position
	rotation = _rotation
	set_scale(_scale)
	#print(global_position)

func rocket():
	$Sprite2D.set_region_rect(Rect2(109.944, 19.996, 18.059, 10.015))

func satelite():
	$Sprite2D.set_region_rect(Rect2(96.921, 37.949, 52.172, 17.01))



func _on_death_clock_timeout() -> void:
	queue_free()
