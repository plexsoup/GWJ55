extends Node

var entity : CharacterBody3D

var current_direction : Vector3 = Vector3.LEFT
var speed : float = 20.0

var last_poll_time : int = 0 #msec
var polling_interval : int = 100 #msec

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(entityObj):
	entity = entityObj


# update the virtual input controller so the NPC acts a lot like a player pressing buttons
func _process(_delta):
	if entity != null and is_instance_valid(entity):
		var ticks = Time.get_ticks_msec()
		if ticks > last_poll_time + polling_interval:
			last_poll_time = ticks
			
			check_raycasts()
			
func check_raycasts():
	if current_direction.x < 0 and $RayCastLeft.is_colliding():
		entity.input_controller.move_left = 1.0
		entity.input_controller.move_right = 0.0
		
	elif current_direction.x > 0 and $RayCastRight.is_colliding():
		entity.input_controller.move_right = 1.0
		entity.input_controller.move_left = 0.0
		
	else: # turn around, your raycast is whiffing air
		current_direction *= -1.0
			
	
