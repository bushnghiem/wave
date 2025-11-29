extends Node2D
var alpha = 0
var alpha_speed = 0.8
var default_modulate = 0
var desired_modulate = 1
var blackout = false
var clear_screen = true
var y_speed = -500

func _ready() -> void:
	$Song.play()

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

func start_asteroids():
	$Asteroid_Spawn.start()

func stop_asteroids():
	$Asteroid_Spawn.stop()

func spin_ccw():
	$Camera2D.ccw_spin_mode = true

func spin_cw():
	$Camera2D.cw_spin_mode2 = true

func zoom_out():
	$Camera2D.zoom_out_mode = true

func zoom_in():
	$Camera2D.zoom_in_mode = true

func _on_asteroid_spawn_timeout() -> void:
	$AsteroidSpawner.spawn_alot(10)


func _on_rhythm_end() -> void:
	#print("blackout")
	blackout = true


func _on_asteroid_start_timeout() -> void:
	start_asteroids()


func _on_asteroid_stop_timeout() -> void:
	stop_asteroids()



func _on_spin_start_timeout() -> void:
	spin_ccw()


func _on_zoom_out_timer_timeout() -> void:
	zoom_out()
