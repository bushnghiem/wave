extends Node2D

@export var asteroid: PackedScene
var y_speed = -500

func _process(delta: float) -> void:
	global_position.y += y_speed*delta

func spawn_asteroid(x_pos, size, rot):
	var rock = asteroid.instantiate()

	# Choose a random location on the SpawnPath.
	# We store the reference to the SpawnLocation node.
	var mob_spawn_location = Vector2(x_pos, global_position.y)
	# And give it a random offset.
	rock.setup(mob_spawn_location, rot, Vector2(size, size))
	# Spawn the mob by adding it to the Main scene.
	get_tree().root.add_child(rock)
