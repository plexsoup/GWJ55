

extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	change_graphics_settings()
	StageManager.current_map = self
	Global.current_map = self

func change_graphics_settings():
	if has_node("Sky and Lighting"):
		$"Sky and Lighting".change_graphics_settings()
