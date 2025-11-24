extends Node2D

func _ready() -> void:
	#$AsteroidSpawner.spawn_asteroid(0, 1, 20)
	get_tree().create_timer(1).timeout.connect(func():
		$Song.play()
	);


func _on_asteroid_spawn_timeout() -> void:
	$AsteroidSpawner.spawn_alot(10)
