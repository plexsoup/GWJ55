extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	$LocationVisualizer.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func activate():
	if Global.current_player:
		Global.current_player.set_global_position(self.global_position)
