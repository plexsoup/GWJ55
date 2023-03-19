extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D
@onready var line = $CanvasLayer/Line2D

const SPEED = 11.0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var target = null
var hold_time = 0.0
var dropped = false
var thrown = false
var cam = null
var throw_vector = Vector3(0,0,0)
var max_points = 50
var render_time = 0.0
@onready var global = get_node("/root/Global")

func _physics_process(delta):
	if target and !dropped and !thrown:
		if !Input.is_action_pressed("throw") and hold_time == 0:
			update_target_location(target.global_position)
			if nav_agent.distance_to_target() > 2 and nav_agent.distance_to_target() < 5:
				set_movement(SPEED/2)
			elif nav_agent.distance_to_target() > 5 and nav_agent.distance_to_target() < 10:
				set_movement(SPEED)
			elif nav_agent.distance_to_target() > 5:
				set_movement(SPEED*2)
		elif Input.is_action_pressed("throw") and global_position.distance_to(target.global_position) < 10:
			hold_time = hold_time + delta
			if hold_time > 0.15:
				var pos = cam.project_position(get_viewport().get_mouse_position(), abs(target.global_position.z - cam.global_position.z))
				throw_vector = (pos - global_position + Vector3(0,10,0))
				if render_time < 0.5:
					update_trajectory(delta)
					render_time = render_time + delta
				else:
					render_time = 0
		elif Input.is_action_just_released("throw") and global_position.distance_to(target.global_position) < 10:
			line.hide()
			if hold_time < 0.15:
				dropped = true
			else:
				velocity = throw_vector
				thrown = true
				dropped = true
			hold_time = 0
		else:
			hold_time = 0
			line.hide()
	elif target and !thrown:
		if !is_on_floor():
			velocity.y -= gravity * delta
			velocity.x = 0
			move_and_slide()
		if Input.is_action_just_released("throw"):
			dropped = false
			line.hide()
	elif target and thrown:
		if !is_on_floor():
			velocity.y -= gravity * delta
			move_and_slide()
			if global_position.distance_to(target.global_position) > 100:
				thrown = false
				dropped = false
		else:
			thrown = false
	if Input.is_action_just_pressed("swap") and (dropped || thrown) and target:
		var save_pos = global_position
		global_position = target.global_position
		target.global_position = save_pos
		
		
func update_trajectory(delta):
	line.show()
	var fast_time = delta * 2
	line.clear_points()
	var pos = global_position
	var pos2D = cam.unproject_position(pos)
	var vel = throw_vector
	#var vel = Vector2(throw_vector.x, -throw_vector.y)
	for i in max_points:
		line.add_point(pos2D)
		vel.y -= gravity * fast_time
		pos += vel * fast_time
		pos2D = cam.unproject_position(pos)
		var mouse_pos = get_viewport().get_mouse_position()
		if pos2D.y > mouse_pos.y + 50 and abs(pos2D.x - mouse_pos.x) < abs(cam.unproject_position(global_position).x - mouse_pos.x)/3:
			break

func update_target_location(target_location):
	nav_agent.target_position = target_location + Vector3(0,2,0)

func _on_area_3d_body_entered(body):
	if body.name == "player" and !dropped:
		target = body
		cam = target.get_node("Camera3D")
		global.kitty = true

func set_movement(speed):
			var current_location = global_transform.origin
			var next_location = nav_agent.get_next_path_position()
			var new_velocity = (next_location - current_location).normalized() * speed
			velocity = new_velocity
			move_and_slide()
