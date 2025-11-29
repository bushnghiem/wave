extends Node2D

@export var asteroid: PackedScene
var y_speed = -500

func _process(delta: float) -> void:
	global_position.y += y_speed*delta

func spawn_asteroid(x_pos, y_off, size, rot, z):
	var rock = asteroid.instantiate()
	var roll = randi_range(1, 50)
	
	if roll == 1:
		rock.rocket()
	elif roll == 2:
		rock.satelite()
	
	var mob_spawn_location = Vector2(x_pos, global_position.y + y_off)
	rock.setup(mob_spawn_location, rot, Vector2(size, size), z)
	get_tree().root.add_child(rock)

func spawn_alot(number):
	for n in number:
		var rand_x = randf_range(-540, 540)
		var rand_size = randf_range(0.5, 2)
		var rand_rot = randf_range(0, 360)
		var rand_y_offset = randf_range(-1000, 500)
		var rand_z = randi_range(0, 1)
		spawn_asteroid(rand_x, rand_y_offset, rand_size, rand_rot, rand_z)
		
