extends Node2D

func _ready() -> void:
	#$AsteroidSpawner.spawn_asteroid(0, 1, 20)
	get_tree().create_timer(1).timeout.connect(func():
		$Song.play()
		$AsteroidSpawner.spawn_asteroid(0, 10, 100)
	);
