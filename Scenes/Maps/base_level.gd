

extends Node3D

@onready var spawn_points = $SpawnPoints


# Called when the node enters the scene tree for the first time.
func _ready():
	change_graphics_settings()
	StageManager.current_map = self
	Global.current_map = self
	if has_node("DevNotes"):
		$DevNotes.hide()

	if StageManager.previous_map_name != null:
		for spawnPoint in spawn_points.get_children():
			if StageManager.previous_map_name.to_lower() in spawnPoint.name.to_lower():
				spawnPoint.activate()

func change_graphics_settings():
	if has_node("Sky and Lighting"):
		$"Sky and Lighting".change_graphics_settings()
