extends Area3D

@export var next_scene_path : String

func _on_body_entered(body):
	if "player" in body.name.to_lower():
		print("You win!")
		StageManager.change_scene_to_file(next_scene_path)
