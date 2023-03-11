extends Button

@export var new_scene : PackedScene
@export var scene_path : String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.





func _on_pressed():
	$ClickNoise.start()
	if new_scene != null:
		get_tree().change_scene_to_packed(new_scene)
	elif scene_path != "":
		get_tree().change_scene_to_file(scene_path)



func _on_mouse_entered():
	$HoverNoise.start()
	
