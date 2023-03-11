extends Node

var entity : CharacterBody3D

var current_direction : Vector3 = Vector3.LEFT
var speed : float = 20.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(entityObj):
	entity = entityObj


# update the virtual input controller so the NPC acts a lot like a player pressing buttons
func _process(delta):
	if entity != null and is_instance_valid(entity):
		if current_direction.x < 0 and $RayCastLeft.is_colliding():
			entity.input_controller.move_left = 1.0
			entity.input_controller.move_right = 0.0
			
		elif current_direction.x > 0 and $RayCastRight.is_colliding():
			entity.input_controller.move_right = 1.0
			entity.input_controller.move_left = 0.0
		
		else: # turn around, your raycast is whiffing air
			current_direction *= -1.0
			
	
