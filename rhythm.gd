extends Node2D
var timeline = []
var press_tracker = []
var song_length = 0
var note_count = 0
var current_note_index = 0
var misses = 0
var hits = 0
var perfects = 0
var goods = 0
var press_left = false
var press_now = false
var perfect_now = false
var clock = 0.0
var done = false
var note_press_time = 0
const note_length = 1.0
const short_note_length = 0.5
const press_window = 0.2
const perfect_window = 0.1

var curse_message = "WHAT A \nHORRIBLE \nNIGHT TO \nHAVE A \nCURSE"

func has_letters(your_string):
	var regex = RegEx.new()
	regex.compile("[a-zA-Z]+")
	if regex.search(str(your_string)):
		return true
	else:
		return false

func _ready() -> void:
	add_notes(10, 0)
	add_notes(5, 1)
	add_notes(5, 0)
	timeline.append("end")
	press_tracker.append("end")

func _unhandled_input(event):
	if Input.is_action_pressed("left"):
		if press_now and press_tracker[current_note_index] == "blank" and press_left:
			if perfect_now:
				press_tracker[current_note_index] = "perfect"
				print("left perfect")
				perfects += 1
				hits += 1
			else:
				press_tracker[current_note_index] = "good"
				print("left good")
				goods += 1
				hits += 1
		else:
			print("left bad")
			misses += 1
	if Input.is_action_pressed("right"):
		if press_now and press_tracker[current_note_index] == "blank" and !press_left:
			if perfect_now:
				press_tracker[current_note_index] = "perfect"
				print("right perfect")
				perfects += 1
				hits += 1
			else:
				press_tracker[current_note_index] = "good"
				print("right good")
				goods += 1
				hits += 1
		else:
			print("right bad")
			misses += 1

func _process(delta: float) -> void:
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
		print(str(perfects) + " perfects")
		print(str(goods) + " goods")
		print(str(hits) + " hits")
		print(str(misses) + " misses")
		
		done = true

func add_notes(new_notes, type):
	var note_holder1
	var note_holder2
	note_count += new_notes
	if type == 0:
		for n in new_notes:
			get_tree().create_timer(song_length + note_length).timeout.connect(func():
				note_holder1 = timeline[current_note_index]
				current_note_index += 1
				note_holder2 = timeline[current_note_index]
				note_press_time += note_length
				print(note_press_time)
				$AudioStreamPlayer.play()
				press_left = !press_left
				if (note_holder1 == "normal" and note_holder2 == "short"):
					$AudioStreamPlayer2.play()
				);
			song_length += note_length
			timeline.append("normal")
			press_tracker.append("blank")
	else:
		for n in new_notes:
			get_tree().create_timer(song_length + short_note_length).timeout.connect(func():
				note_holder1 = timeline[current_note_index]
				current_note_index += 1
				note_holder2 = timeline[current_note_index]
				note_press_time += short_note_length
				print(note_press_time)
				$AudioStreamPlayer.play()
				press_left = !press_left
				if (note_holder1 == "short" and note_holder2 == "normal"):
					$AudioStreamPlayer2.play()
				);
			song_length += short_note_length
			timeline.append("short")
			press_tracker.append("blank")
