extends MeshInstance3D
signal switch_hit

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_area_3d_body_entered(body):
	if "player" in body.name.to_lower():
		emit_signal("switch_hit")
