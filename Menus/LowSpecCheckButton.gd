extends CheckButton

@export var high_spec_scene_path : String

# Called when the node enters the scene tree for the first time.
func _ready():
	#button_pressed = Global.low_spec
	pass



func _on_toggled(btnPressed):
	Global.low_spec = !btnPressed
	StageManager.change_scene_to_file(high_spec_scene_path)
