extends Node

var current_map # instantiated scene object
var current_map_packed_scene : PackedScene # useful for restarting the level
# Called when the node enters the scene tree for the first time.
@onready var fade_transition = preload("res://Cutscenes/fade_transition.tscn")
var current_transition

func fade_out():
	current_transition = fade_transition.instantiate()
	add_child(current_transition)
	await current_transition.finished
	current_transition.fade_out()
	
func fade_in():
	current_transition.fade_in()
	

func change_scene_to_packed(packedScene : PackedScene):
	# play a fade-out, load the new scene, play a fade in.
	
	fade_out()
	
	get_tree().change_scene_to_packed(packedScene)
	current_map_packed_scene = packedScene
	fade_in()

func change_scene_to_file(scenePath : String):
	change_scene_to_packed(load(scenePath))


func reset_level():
	get_tree().reload_current_scene()
	#change_scene_to_packed(current_map_packed_scene)
