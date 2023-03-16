extends CheckButton

@export var high_spec_scene_path : String

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.low_spec = button_pressed




func _on_toggled(button_pressed):
	Global.low_spec = !button_pressed
	StageManager.change_scene_to_file(high_spec_scene_path)
