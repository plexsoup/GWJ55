extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	$LocationVisualizer.hide()




func activate():
	if Global.current_player:
		Global.current_player.set_global_position(self.global_position)
