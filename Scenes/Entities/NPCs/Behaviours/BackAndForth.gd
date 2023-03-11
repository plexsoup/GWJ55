#extends "res://Scenes/Entities/NPCs/Behaviours/base_behaviour.gd"
#In Godot, you can ctrl-click on class names to view the superclass script.
extends BaseNPCBehaviour
# Base NPC Behaiour calls update_input_controller() at a specified polling interval

func _ready():
	super._ready()

func _process(delta):
	super._process(delta)


func update_input_controller():
	if current_direction.x < 0 and $RayCastLeft.is_colliding():
		entity.input_controller.move_left = 1.0
		entity.input_controller.move_right = 0.0
		
	elif current_direction.x > 0 and $RayCastRight.is_colliding():
		entity.input_controller.move_right = 1.0
		entity.input_controller.move_left = 0.0
		
	else: # turn around, your raycast is whiffing air
		current_direction *= -1.0
			
	
