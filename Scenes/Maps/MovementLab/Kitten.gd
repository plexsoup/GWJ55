extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D

const SPEED = 11.0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var target = null

func _physics_process(_delta):
	if target:
		update_target_location(target.global_position)
		if nav_agent.distance_to_target() > 2 and nav_agent.distance_to_target() < 5:
			set_movement(SPEED/2)
		elif nav_agent.distance_to_target() > 5 and nav_agent.distance_to_target() < 10:
			set_movement(SPEED)
		elif nav_agent.distance_to_target() > 5:
			set_movement(SPEED*2)

func update_target_location(target_location):
	nav_agent.target_position = target_location + Vector3(0,2,0)

func _on_area_3d_body_entered(body):
	if body.name == "player":
		target = body

func set_movement(speed):
			var current_location = global_transform.origin
			var next_location = nav_agent.get_next_path_position()
			var new_velocity = (next_location - current_location).normalized() * speed
			velocity = new_velocity
			move_and_slide()
