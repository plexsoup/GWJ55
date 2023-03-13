"""
- for level designers.
- to see where moving platforms go.
"""

@tool
extends MeshInstance3D

var last_polling_time : int = 0
var polling_interval : int = 2000



# Called when the node enters the scene tree for the first time.
func _ready():
	if Engine.is_editor_hint(): # running in editor
		move_to_platform_destination()
	else:
		hide()

func _process(delta):
	if Engine.is_editor_hint():
		if Time.get_ticks_msec() > last_polling_time + polling_interval:
			last_polling_time = Time.get_ticks_msec()
			move_to_platform_destination()


func move_to_platform_destination():
	var platform = get_parent()
	if platform.get("range") is Vector3:
		global_position = platform.global_position + platform.range
	
