extends Node3D




func _unhandled_input(_event):
	if Input.is_action_just_pressed("spawn_box"):
		spawn_box()
		
func spawn_box():
	var box = preload("res://Scenes/Objects/RigidBodyBox.tscn").instantiate()
	var offsetDistance = 1.5
	
	StageManager.current_map.add_child(box)
	var newPosition = self.global_position + ( Vector3.RIGHT * offsetDistance )
	
	box.set_global_position( newPosition )
	
	
