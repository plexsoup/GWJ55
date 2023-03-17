extends Node3D




func _unhandled_input(_event):
	if Input.is_action_just_pressed("spawn_box"):
		spawn_box()
		
func spawn_box():
	var box = preload("res://Scenes/Objects/RigidBodyBox.tscn").instantiate()
	var offsetDistance = 10.0
	StageManager.current_map.add_child(box)
	box.set_global_position( self.get_global_position() + (Vector3(Global.current_player.input_dir, 0, 0) * offsetDistance) )
	
	
