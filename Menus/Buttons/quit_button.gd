extends "res://Menus/Buttons/scene_change_button.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_pressed():
	# quit game
	$ClickNoise.start()
	await get_tree().create_timer(0.3).timeout
	get_tree().quit()
	
