extends Node3D

@export var volume_db : float = 9.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func start():
	play_random_noise()

func play_random():
	play_random_noise()
	
func play_random_noise():
	var randSound = get_children().pick_random()
	randSound.set_volume_db(volume_db)
	randSound.start()
	
