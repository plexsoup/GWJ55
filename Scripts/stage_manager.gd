extends Node

var current_map # instantiated scene object
var current_map_packed_scene : PackedScene # useful for restarting the level
var fade_transition
var current_transition
var main

var music_player_scene = "res://Scripts/Music/play_random_music.tscn"
var music_player

func _ready():
# removed by RonnocJ.
#	music_player = load(music_player_scene).instantiate()
#	add_child(music_player)
	pass

func fade_out():
	
	fade_transition.get_node("AnimationPlayer").play("fog_fade_out")
	
	
func fade_in():
	fade_transition.play_fade_in()
	

func change_scene_to_packed(packedScene : PackedScene):
	# play a fade-out, load the new scene, play a fade in.
	var new_scene = packedScene.instantiate()
	fade_out()
	# ResourceLoader.load_threaded_request()
	await fade_transition.finished
	
	main.remove_child(current_map)
	main.add_child(new_scene)
	
	current_map_packed_scene = packedScene
	fade_in()

func change_scene_to_file(scenePath : String):
	change_scene_to_packed(load(scenePath))


func reset_level():
	#get_tree().reload_current_scene()
	change_scene_to_packed(current_map_packed_scene)
