extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D

const SPEED = 11.0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var target = null
var hold_time = 0.0
var dropped = false

func _physics_process(delta):
	if target and !dropped:
		if !Input.is_action_pressed("throw") and hold_time == 0:
			update_target_location(target.global_position)
			if nav_agent.distance_to_target() > 2 and nav_agent.distance_to_target() < 5:
				set_movement(SPEED/2)
			elif nav_agent.distance_to_target() > 5 and nav_agent.distance_to_target() < 10:
				set_movement(SPEED)
			elif nav_agent.distance_to_target() > 5:
				set_movement(SPEED*2)
		elif Input.is_action_pressed("throw"):
			hold_time = hold_time + delta
		elif Input.is_action_just_released("throw"):
			print(hold_time)
			if hold_time < 0.25:
				dropped = true
			else:
				print("throw")
			hold_time = 0
	else:
		if !is_on_floor():
			var new_velocity = Vector3(0, -1, 0) * SPEED
			velocity = new_velocity
			move_and_slide()
		if Input.is_action_just_released("throw"):
			dropped = false
			
func update_target_location(target_location):
	nav_agent.target_position = target_location + Vector3(0,2,0)

func _on_area_3d_body_entered(body):
	if body.name == "player" and !dropped:
		target = body

func set_movement(speed):
			var current_location = global_transform.origin
			var next_location = nav_agent.get_next_path_position()
			var new_velocity = (next_location - current_location).normalized() * speed
			velocity = new_velocity
			move_and_slide()
