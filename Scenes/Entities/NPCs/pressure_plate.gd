extends Node3D

var plunger_distance : float = 0.165
var starting_position : Vector3
var pressed : bool = false

@export var connected_to: Array[NodePath] # figure out how to define subtype of an array. I know it's possible, I've done it before.

signal switch_toggled

# Called when the node enters the scene tree for the first time.
func _ready():
	starting_position = $PlungerMesh.position
	for nodePath in connected_to:
		if !nodePath.is_empty():
			var destinationObject = get_node(nodePath)
			if destinationObject.has_method("_on_switch_toggled"):
				switch_toggled.connect(destinationObject._on_switch_toggled)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_area_3d_body_entered(_body):
	if occupant_count() == 1:
		#print("pressure_plate works, detected ", body.name)
		var tween = get_tree().create_tween()
		tween.tween_property($PlungerMesh, "position", $PlungerMesh.position + (Vector3.DOWN * plunger_distance * scale.y), 0.35)
		$PressedNoises.play_random_sound()
		pressed = true
		switch_toggled.emit(pressed)


func _on_area_3d_body_exited(_body):
	if !is_instance_valid(self):
		return
	if occupant_count() == 0:
		var tween = get_tree().create_tween()
		tween.tween_property($PlungerMesh, "position", starting_position, 0.20)
		if $ReleasedNoises.is_inside_tree():
			$ReleasedNoises.play_random_sound()
			pressed = false
			switch_toggled.emit(pressed)


func occupant_count() -> int:
	var occupants = 0
	var potentialOccupants = $Area3D.get_overlapping_bodies()
	if potentialOccupants.size() > 0:
		for body in potentialOccupants:
			if body.is_in_group("heavy"):
				occupants += 1
	return occupants
	
