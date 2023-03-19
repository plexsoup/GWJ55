extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _pressed():
	# quit game
	$ClickNoise.start()
	await get_tree().create_timer(0.3).timeout
	get_tree().quit()
	
