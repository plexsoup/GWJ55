extends Node3D

@export var rotate : bool = false
@export var duration : float = 0.5
@export var open_on_previous_map_name : String = ""

var rotation_axis : Vector3 = Vector3(0, 1, 0)
var starting_rotation : float = 0.0
var full_rotation : float = PI/2.0 # ninety degrees

var starting_position : Vector3
var final_position : Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	starting_position = $Hinge.position
	var door_length = $Hinge/MeshInstance3D.get_aabb().get_longest_axis_size()
	final_position = starting_position + Vector3.DOWN * door_length * $Hinge/MeshInstance3D.get_scale().y 
	if open_on_previous_map_name != "" and StageManager.previous_map_name != "":
		if StageManager.previous_map_name.to_lower() in open_on_previous_map_name.to_lower():
			queue_free()

func _on_switch_toggled(value):
	if value == true:
		open()
	else:
		close()
		
func open():
	var tween = get_tree().create_tween()
	if has_node("Hinge") and is_instance_valid($Hinge):
		if rotate:
				tween.tween_property($Hinge, "rotation", rotation_axis * full_rotation, duration)
		else:
			tween.tween_property($Hinge, "position", final_position, duration )
	$OpenNoises.play_random_sound()
		
func close():
	# throws errors if user restarts level while on a platform
	if is_instance_valid(self):
		var tween = get_tree().create_tween()
		if has_node("Hinge") and is_instance_valid($Hinge):
			if rotate:
					tween.tween_property($Hinge, "rotation", rotation_axis * starting_rotation, 1.0)
			else:
				tween.tween_property($Hinge, "position", starting_position, duration)
		
