extends Node3D

var plunger_distance : float = 0.165
var starting_position : Vector3
var pressed : bool = false

var connected_to : Array # figure out how to define subtype of an array. I know it's possible, I've done it before.

# Called when the node enters the scene tree for the first time.
func _ready():
	starting_position = $PlungerMesh.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_area_3d_body_entered(body):
	if occupant_count() == 1:
		print("pressure_plate works, detected ", body.name)
		var tween = get_tree().create_tween()
		tween.tween_property($PlungerMesh, "position", $PlungerMesh.position + (Vector3.DOWN * plunger_distance * scale.y), 0.35)
		$ClickNoise.play()
		pressed = true


func _on_area_3d_body_exited(body):
	if occupant_count() == 0:
		var tween = get_tree().create_tween()
		tween.tween_property($PlungerMesh, "position", starting_position, 0.20)
		$ReleaseNoise.play()
		pressed = false

	
	
func occupant_count() -> int:
	var occupant_count = 0
	var potentialOccupants = $Area3D.get_overlapping_bodies()
	if potentialOccupants.size() > 0:
		for body in potentialOccupants:
			if body.is_in_group("heavy"):
				occupant_count += 1
	return occupant_count
	
