extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.





func _on_body_entered(body):
	if "player" in body.name.to_lower():
		Global.player_stats["health"] -= 1
		if Global.player_stats["health"] <= 0:
			StageManager.change_scene_to_file("res://Menus/death_screen.tscn")
		else:
			StageManager.reset_level()
		
