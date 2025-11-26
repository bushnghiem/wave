extends Node2D
var alpha = 0
var alpha_speed = 0.8
var default_modulate = 0
var desired_modulate = 1
var blackout = false
var clear_screen = true
var y_speed = -500

func _ready() -> void:
	#$AsteroidSpawner.spawn_asteroid(0, 1, 20)
	get_tree().create_timer(1).timeout.connect(func():
		$Song.play()
	);

func _process(delta: float) -> void:
	$Blackout.global_position.y += y_speed*delta
	#print($Blackout.self_modulate.a)
	if clear_screen:
		if alpha < 1:
			alpha += delta * alpha_speed
			var new_mod = lerpf(desired_modulate, default_modulate, alpha)
			$Blackout.self_modulate.a = new_mod
		else:
			#print("screen clear")
			clear_screen = false
			alpha = 0
	if blackout:
		alpha += delta * alpha_speed
		var new_mod = lerpf(default_modulate, desired_modulate, alpha)
		$Blackout.self_modulate.a = new_mod


func _on_asteroid_spawn_timeout() -> void:
	$AsteroidSpawner.spawn_alot(10)


func _on_rhythm_end() -> void:
	print("blackout")
	blackout = true
