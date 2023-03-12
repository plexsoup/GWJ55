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
		entity.input_controller.press_key("move_left")
		entity.input_controller.release_key("move_right")
		
	elif current_direction.x > 0 and $RayCastRight.is_colliding():
		entity.input_controller.press_key("move_right")
		entity.input_controller.release_key("move_left")
		
	else: # turn around, your raycast is whiffing air
		current_direction *= -1.0
			
	
