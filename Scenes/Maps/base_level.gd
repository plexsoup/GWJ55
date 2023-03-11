extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	StageManager.current_map = self
	Global.current_map = self


