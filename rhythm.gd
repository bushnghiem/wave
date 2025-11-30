extends Node2D

signal perfect
signal good
signal mistake
signal left
signal right
signal end
signal end_of_tutorial
signal swap_to_fast_left
signal swap_to_norm_left
signal swap_to_fast_right
signal swap_to_norm_right

var timeline = []
var press_tracker = []
var song_length = 0
var note_count = 0
var current_note_index = 0
var misses = 0.0
var hits = 0.0
var perfects = 0.0
var goods = 0.0
var press_left = true
var press_now = false
var perfect_now = false
var clock = 0.0
var done = false
var note_press_time = 0
var note_check = false
var total = 0.0
var hit_ratio = 0.0
var perfect_ratio = 0.0
@export var start_delay = 2.0
var metronome_count = 0
@export var metronome_limit = 0
@export var auto_play = false
@export var tutorial = false
@export var tutorial_part = 1
const win_ratio_threshold = 0.7
const good_win_ratio = 0.7
const note_length = 1.0
const short_note_length = 0.5
const press_window = 0.2
const perfect_window = 0.1
@export var end_screen_delay = 4.0

var curse_message = "WHAT A \nHORRIBLE \nNIGHT TO \nHAVE A \nCURSE"

func has_letters(your_string):
	var regex = RegEx.new()
	regex.compile("[a-zA-Z]+")
	if regex.search(str(your_string)):
		return true
	else:
		return false

func _ready() -> void:
	connect_all_npc()
	#if tutorial_part != 2:
		#$AudioStreamPlayer3.play()
	note_press_time += start_delay
	done = true
	if tutorial_part != 2:
		get_tree().create_timer(start_delay + 0.5).timeout.connect(func():
			done = false
			);
	else:
		get_tree().create_timer(start_delay + 0.25).timeout.connect(func():
			done = false
			);
	if tutorial:
		tutorial_parts(tutorial_part)
	else:
		#Main level
		add_notes(16, 0) #20
		add_notes(4, 1) #22
		add_notes(2, 0) #24
		add_notes(4, 1) #26
		add_notes(2, 0) #28
		add_notes(4, 1) #30
		add_notes(2, 0) #32
		add_notes(4, 1) #34
		add_notes(18, 0) #52
		add_notes(2, 1) #53
		add_notes(1, 0) #54
		add_notes(2, 1) #55
		add_notes(1, 0) #56
		add_notes(2, 1) #57
		add_notes(1, 0) #58
		add_notes(2, 1) #59
		add_notes(1, 0) #60
		add_notes(2, 1) #61
		add_notes(1, 0) #62
		add_notes(2, 1) #63
		add_notes(1, 0) #64
		add_notes(2, 1) #65
		add_notes(1, 0) #66
		add_notes(4, 0) #70
		add_notes(28, 1) #84
		add_notes(16, 0) #100
		add_notes(2, 1) #101
		add_notes(1, 0) #102
		add_notes(2, 1) #103
		add_notes(1, 0) #104
		add_notes(2, 1) #105
		add_notes(1, 0) #106
		add_notes(2, 1) #107
		add_notes(1, 0) #108
		add_notes(2, 1) #109
		add_notes(1, 0) #110
		add_notes(2, 1) #112
		add_notes(1, 0) #113
		add_notes(2, 1) #114
		add_notes(1, 0) #115
		add_notes(2, 1) #116
		add_notes(1, 0) #117
		add_notes(2, 1) #118
		add_notes(1, 0) #119
		add_notes(6, 0) #125
		add_end()

func connect_all_npc():
	var npcs = get_tree().get_nodes_in_group("NPC")
	for npc in npcs:
		swap_to_fast_left.connect(npc.swap_to_fast_left)
		swap_to_norm_left.connect(npc.swap_to_norm_left)
		swap_to_fast_right.connect(npc.swap_to_fast_right)
		swap_to_norm_right.connect(npc.swap_to_norm_right)

func tutorial_parts(part):
	if part == 1:
		#metronome_limit = 100000
		add_notes(4, 0)
		add_end()
	elif part == 2:
		#metronome_limit = 100000
		$Metronome.stop()
		$Metronome.wait_time = 0.5
		$Metronome.start()
		add_notes(4, 1)
		add_end()
	elif part == 3:
		#metronome_limit = 100000
		add_notes(4, 0)
		add_notes(4, 1)
		add_notes(4, 0)
		add_end()

func _unhandled_input(event):
	if !done:
		if Input.is_action_pressed("left"):
			if !auto_play:
				left_button()
		if Input.is_action_pressed("right"):
			if !auto_play:
				right_button()
		if Input.is_action_pressed("reset"):
			if !tutorial:
				reset_button()
	
	if Input.is_action_pressed("quit"):
		quit_button()

func left_button():
	left.emit()
	#print(press_now)
	#print("pressed left")
	if press_now and press_tracker[current_note_index] == "blank" and press_left:
		if perfect_now:
			press_tracker[current_note_index] = "perfect"
			perfect.emit()
			#print("perfect")
			perfects += 1
			hits += 1
		else:
			press_tracker[current_note_index] = "good"
			good.emit()
			#print("good")
			goods += 1
			hits += 1
	else:
		press_tracker[current_note_index] = "bad"
		mistake.emit()
		#print("mistake")
		misses += 1

func right_button():
	#print("pressed right")
	#print(press_now)
	right.emit()
	if press_now and press_tracker[current_note_index] == "blank" and !press_left:
		if perfect_now:
			press_tracker[current_note_index] = "perfect"
			perfect.emit()
			#print("perfect")
			perfects += 1
			hits += 1
		else:
			press_tracker[current_note_index] = "good"
			good.emit()
			#print("good")
			goods += 1
			hits += 1
	else:
		press_tracker[current_note_index] = "bad"
		mistake.emit()
		#print("mistake")
		misses += 1

func reset_button():
	get_tree().change_scene_to_file("res://Levels/game.tscn")

func quit_button():
	get_tree().change_scene_to_file("res://Levels/title_screen.tscn")

func _process(delta: float) -> void:
	#print(clock)
	clock += delta
	if (clock > (note_press_time - press_window)) and (clock < (note_press_time + press_window)):
		
		#print("press now")
		press_now = true
		if (clock > (note_press_time - perfect_window)) and (clock < (note_press_time + perfect_window)):
			perfect_now = true
		else:
			perfect_now = false
	else:
		#if (clock < (note_press_time - press_window)):
			#print("dont press now: " + str(clock) + " < " + str(note_press_time - press_window))
		#elif (clock > (note_press_time + press_window)):
			#print("dont press now: " + str(clock) + " > " + str(note_press_time + press_window))
		press_now = false
	if timeline[current_note_index] == "end" and !done:
		end.emit()
		get_tree().create_timer(end_screen_delay).timeout.connect(func():
				#print(str(perfects) + " perfects")
				#print(str(goods) + " goods")
				#print(str(hits) + " hits")
				#print(str(misses) + " misses")
				calculate_score()
				);
		done = true

func calculate_score():
	total = hits + misses
	hit_ratio = hits / total
	perfect_ratio = perfects / hits
	if hit_ratio >= win_ratio_threshold:
		#print("victory")
		if tutorial:
			if tutorial_part < 3:
				get_tree().change_scene_to_file("res://Levels/pre_tutorial_" + str(tutorial_part + 1) + ".tscn")
			elif tutorial_part >= 3:
				end_of_tutorial.emit()
				get_tree().create_timer(end_screen_delay).timeout.connect(func():
					get_tree().change_scene_to_file("res://Levels/game.tscn")
				);
		else:
			if perfect_ratio == 1 and misses == 0:
				#print("perfect victory")
				get_tree().change_scene_to_file("res://Levels/win_screen_3.tscn")
			elif perfect_ratio >= good_win_ratio:
				#print("good victory")
				get_tree().change_scene_to_file("res://Levels/win_screen_2.tscn")
			else:
				get_tree().change_scene_to_file("res://Levels/win_screen_1.tscn")
	else:
		#print("loser")
		if tutorial:
			get_tree().change_scene_to_file("res://Levels/pre_tutorial_" + str(tutorial_part) + ".tscn")
		else:
			get_tree().change_scene_to_file("res://Levels/fail_screen.tscn")
	

func add_notes(new_notes, type):
	var note_holder
	var note_holder1
	var note_holder2
	note_count += new_notes
	if type == 0:
		for n in new_notes:
			get_tree().create_timer(start_delay + song_length + note_length - press_window).timeout.connect(func():
				note_press_time += note_length
				#print(note_press_time)
			);
			get_tree().create_timer(start_delay + song_length + note_length).timeout.connect(func():
				note_holder1 = timeline[current_note_index]
				note_holder2 = timeline[current_note_index + 1]
				$AudioStreamPlayer.play()
				if (note_holder1 == "normal" and note_holder2 == "short"):
					$AudioStreamPlayer2.play()
					if press_left:
						#print("press_left is true right now, thus you will press left and should swap to fast right")
						swap_to_fast_right.emit()
					else:
						#print("press_left is false right now, thus you will press right and should swap to fast left")
						swap_to_fast_left.emit()
					if tutorial and tutorial_part == 3:
						$AudioStreamPlayer3.play()
						$Metronome.stop()
						$Metronome.wait_time = 0.5
						$Metronome.start()
				);
			get_tree().create_timer(start_delay + song_length + note_length - perfect_window / 2).timeout.connect(func():
				if auto_play:
					if press_left:
						left_button()
					else:
						right_button()
				);
			get_tree().create_timer(start_delay + song_length + note_length + press_window).timeout.connect(func():
				note_holder = press_tracker[current_note_index]
				if (note_holder == "blank"):
					press_tracker[current_note_index ] = "bad"
					mistake.emit()
					misses += 1
				current_note_index += 1
				press_left = !press_left
				);
			song_length += note_length
			timeline.append("normal")
			press_tracker.append("blank")
	else:
		for n in new_notes:
			get_tree().create_timer(start_delay + song_length + short_note_length - press_window).timeout.connect(func():
				note_press_time += short_note_length
				#print(note_press_time)
			);
			get_tree().create_timer(start_delay + song_length + short_note_length).timeout.connect(func():
				note_holder1 = timeline[current_note_index]
				note_holder2 = timeline[current_note_index+1]
				$AudioStreamPlayer.play()
				if (note_holder1 == "short" and note_holder2 == "normal"):
					$AudioStreamPlayer2.play()
					if press_left:
						#print("press_left is true right now, thus you will press left and should swap to normal right")
						swap_to_norm_right.emit()
					else:
						#print("press_left is false right now, thus you will press right and should swap to normal left")
						swap_to_norm_left.emit()
					if tutorial and tutorial_part == 3:
						$AudioStreamPlayer3.play()
						$Metronome.stop()
						$Metronome.wait_time = 1
						$Metronome.start()
				);
			get_tree().create_timer(start_delay + song_length + short_note_length - perfect_window / 2).timeout.connect(func():
				if auto_play:
					if press_left:
						left_button()
					else:
						right_button()
				);
			get_tree().create_timer(start_delay + song_length + short_note_length + press_window).timeout.connect(func():
				note_holder = press_tracker[current_note_index]
				if (note_holder == "blank"):
					press_tracker[current_note_index] = "bad"
					mistake.emit()
					#print("miss")
					misses += 1
				press_left = !press_left
				current_note_index += 1
				);
			song_length += short_note_length
			timeline.append("short")
			press_tracker.append("blank")

func add_end():
	timeline.append("end")
	press_tracker.append("end")


func _on_metronome_timeout() -> void:
	metronome_count += 1
	$AudioStreamPlayer3.play()
	if metronome_count < metronome_limit:
		$Metronome.start()
	
