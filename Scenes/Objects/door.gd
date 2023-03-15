extends Node3D

var rotation_axis : Vector3 = Vector3(0, 1, 0)
var starting_rotation : float = 0.0
var full_rotation : float = PI/2.0 # ninety degrees

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_switch_toggled(value):
	if value == true:
		open()
	else:
		close()
		
func open():
	var tween = get_tree().create_tween()
	if has_node("Hinge") and is_instance_valid($Hinge):
		tween.tween_property($Hinge, "rotation", rotation_axis * full_rotation, 1.0)
	
		
func close():
	# throws errors if user restarts level while on a platform
	if is_instance_valid(self):
		var tween = get_tree().create_tween()
		if has_node("Hinge") and is_instance_valid($Hinge):
			tween.tween_property($Hinge, "rotation", rotation_axis * starting_rotation, 1.0)
