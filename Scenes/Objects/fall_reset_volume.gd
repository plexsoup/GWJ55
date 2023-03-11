extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.





func _on_body_entered(body):
	if "player" in body.name.to_lower():
		StageManager.reset_level()
		
