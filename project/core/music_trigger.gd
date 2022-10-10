extends Trigger

@export var song : Music.Songs
@export var previous_song_fade_out_time := 0.0


func trigger(_dummy_var=null) -> void:
	MusicManager.play(song, previous_song_fade_out_time)
	super.trigger()
