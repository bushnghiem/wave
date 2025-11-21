extends Node2D

signal perfect
signal good
signal mistake
signal left
signal right
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
var start_delay = 2
var metronome_count = 0
var metronome_limit = 0
@export var auto_play = false
@export var tutorial = false
@export var tutorial_part = 1
const win_ratio_threshold = 0.7
const good_win_ratio = 0.5
const note_length = 1.0
const short_note_length = 0.5
const press_window = 0.2
const perfect_window = 0.1
const end_screen_delay = 1.0

var curse_message = "WHAT A \nHORRIBLE \nNIGHT TO \nHAVE A \nCURSE"

func has_letters(your_string):
	var regex = RegEx.new()
	regex.compile("[a-zA-Z]+")
	if regex.search(str(your_string)):
		return true
	else:
		return false

func _ready() -> void:
	$AudioStreamPlayer3.play()
	note_press_time += start_delay
	done = true
	get_tree().create_timer(start_delay + 1).timeout.connect(func():
		done = false
		);
	if tutorial:
		tutorial_parts(tutorial_part)
	else:
		metronome_limit = start_delay * 2 - 1
		add_notes(2, 0)
		add_notes(2, 1)
		add_notes(4, 0)
		add_notes(4, 1)
		add_notes(6, 0)
		add_notes(6, 1)
		add_notes(8, 0)
		add_notes(8, 1)
		add_end()

func tutorial_parts(part):
	if part == 1:
		metronome_limit = 100000
		add_notes(4, 0)
		add_end()
	elif part == 2:
		metronome_limit = 100000
		$Metronome.stop()
		$Metronome.wait_time = 0.5
		$Metronome.start()
		add_notes(4, 1)
		add_end()
	elif part == 3:
		metronome_limit = 100000
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

func left_button():
	left.emit()
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
	get_tree().change_scene_to_file("res://Levels/pre_main_level.tscn")

func _process(delta: float) -> void:
	#print(press_left)
	clock += delta
	if (clock > (note_press_time - press_window)) and (clock < (note_press_time + press_window)):
		press_now = true
		if (clock > (note_press_time - perfect_window)) and (clock < (note_press_time + perfect_window)):
			perfect_now = true
		else:
			perfect_now = false
	else:
		press_now = false
	if timeline[current_note_index] == "end" and !done:
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
				get_tree().change_scene_to_file("res://Levels/pre_main_level.tscn")
		else:
			if perfect_ratio == 1:
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
			get_tree().create_timer(start_delay + song_length + note_length).timeout.connect(func():
				note_holder1 = timeline[current_note_index]
				note_holder2 = timeline[current_note_index + 1]
				note_press_time += note_length
				#print(note_press_time)
				$AudioStreamPlayer.play()
				if (note_holder1 == "normal" and note_holder2 == "short"):
					$AudioStreamPlayer2.play()
					if press_left:
						print("press_left is true right now, thus you will press left and should swap to fast right")
						swap_to_fast_right.emit()
					else:
						print("press_left is false right now, thus you will press right and should swap to fast left")
						swap_to_fast_left.emit()
					if tutorial and tutorial_part == 3:
						$AudioStreamPlayer3.play()
						$Metronome.stop()
						$Metronome.wait_time = 0.5
						$Metronome.start()
				);
			get_tree().create_timer(start_delay + song_length + note_length + perfect_window / 2).timeout.connect(func():
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
			get_tree().create_timer(start_delay + song_length + short_note_length).timeout.connect(func():
				note_holder1 = timeline[current_note_index]
				note_holder2 = timeline[current_note_index+1]
				note_press_time += short_note_length
				print(note_press_time)
				$AudioStreamPlayer.play()
				if (note_holder1 == "short" and note_holder2 == "normal"):
					$AudioStreamPlayer2.play()
					if press_left:
						print("press_left is true right now, thus you will press left and should swap to normal right")
						swap_to_norm_right.emit()
					else:
						print("press_left is false right now, thus you will press right and should swap to normal left")
						swap_to_norm_left.emit()
					if tutorial and tutorial_part == 3:
						$AudioStreamPlayer3.play()
						$Metronome.stop()
						$Metronome.wait_time = 1
						$Metronome.start()
				);
			get_tree().create_timer(start_delay + song_length + short_note_length + perfect_window / 2).timeout.connect(func():
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
					print("miss")
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
	
