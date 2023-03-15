extends Node

@export var play_this_one_first : NodePath
var first_track : AudioStreamPlayer
var playlist : Array = []
var current_player : AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	build_playlist()
	play_random_track()



func build_playlist():
	if not play_this_one_first.is_empty():
		first_track = get_node(play_this_one_first)

	var possibleTracks = get_children()
	var tracks = []
	for track in possibleTracks:
		if track is AudioStreamPlayer and track.stream != null and track != first_track:
			tracks.push_back(track)
	tracks.shuffle()
	if first_track != null:
		tracks.push_back(first_track)
	
	playlist = tracks.duplicate()


func play_random_track():
	# the playlist is already randomized. Treat it like a deck of cards.
	if playlist.size() > 0:
		current_player = playlist.pop_back()
		current_player.play()
		current_player.finished.connect(_on_song_finished)
	else:
		build_playlist()
		play_random_track()


func _on_song_finished():
	current_player.finished.disconnect(_on_song_finished)
	play_random_track()
