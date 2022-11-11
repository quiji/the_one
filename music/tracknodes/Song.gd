extends Node

const COMPENSATE_FRAMES = 2
const COMPENSATE_HZ = 60.0

export (int) var bpm = 60
export (int) var bars = 4
export (int) var transition_idx = 0

var current_track_idx: int = 0
var current_track = null
var total_beats: int

func _ready():
	set_process(false)

func get_total_transitions() -> int:
	return get_child_count()

func play() -> void:
	current_track_idx = 0
	
	_play_track()

func _play_track() -> void:
	if current_track_idx < get_child_count():
		
		if current_track != null:
			current_track.stop()
			
		current_track = get_child(current_track_idx)
		current_track.play()
		set_process(true)
		total_beats = int(current_track.stream.get_length() * bpm / 60.0)


func _process(delta):
	
	var time: float = 0.0
	time = current_track.get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency() + (1 / COMPENSATE_HZ) * COMPENSATE_FRAMES

	var beat = int(time * bpm / 60.0)

	if (beat + 1) > total_beats:
		beat = 0
	
	var measure :int = floor(beat / bars) + 1
		
	if (measure - 1) % current_track.transition_measure_count == 0 and current_track_idx != transition_idx:
		# Transit!
		current_track_idx = transition_idx
		_play_track()

	
	#Console.add_log("current_track", current_track.name)
	#Console.add_log("current_track_idx", current_track_idx)
	#Console.add_log("TRANSITION_MEASURE_MET", (measure - 1) % current_track.transition_measure_count == 0)
	#Console.add_log("TOTAL_BEATS", total_beats)
	#Console.add_log("BEATS", beat + 1)
	#Console.add_log("BEAT", str(beat % bars + 1, "/", bars))
	#Console.add_log("MEASURE", measure)
	
