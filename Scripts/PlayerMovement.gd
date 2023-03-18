extends CharacterBody3D

@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float

@onready var jump_velocity : float = (2.0 * jump_height) / jump_time_to_peak
@onready var jump_gravity : float = (-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)
@onready var fall_gravity : float = (-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)
@onready var coyote_time = $CoyoteTime
@onready var jump_buffer = $JumpBuffer
@onready var animated_sprite = $AnimatedSprite3D
@onready var dash_timer = $DashTimer
@onready var dash_cooldown = $DashCooldown
@onready var throw_point = $ThrowPoint

var kitten = null

const SPEED = 11.0
var buffered_jump = false
var was_on_floor
var double_jump = false
var animation_state = "Idle"
var previous_animation_state
var previous_animation_frame : int
var input_dir
var jumping = false
var dashing = false
var on_dash_cooldown = false
var dash_usable = true


var climb_side = "none"
var climb_flip = 0

var last_knockback_time : float = 0.0
var knockback_duration : float = 600 # ms

enum States { READY, KNOCKBACK, DYING }
var state = States.READY


var no_clip_mode : bool = false
var noclip_speed = 500.0

func _ready():
	Global.current_player = self

func _physics_process(delta):
	if state in [ States.READY ]:
		check_climb()
		check_stairs()
		set_gravity_states(delta)
		handle_dash()
		if !dashing and !on_dash_cooldown:
			handle_jump()
			if !no_clip_mode:
				move()
			else:
				move_noclip(delta)

		move_and_slide()
		update_gravity_states()
		animate()
		play_audio()
		previous_animation_frame = animated_sprite.get_frame()
	elif state == States.KNOCKBACK:
		execute_knockback(delta)

func wind_throw():
	pass

func throw():
	pass

func _unhandled_input(_event):
	if Input.is_action_just_pressed("no_clip"):
		no_clip_mode = !no_clip_mode
		if no_clip_mode:
			set_collision_layer_value(1, false)
			set_collision_mask_value(3, false)
			print("no_clip ghost mode enabled")
		else:
			set_collision_layer_value(1, true)
			set_collision_mask_value(3, true)
			print("no_clip ghost mode disabled")


func check_stairs():
	if is_on_wall():
		if has_node("BonusBehaviours/AscendStairs"):
			$BonusBehaviours/AscendStairs.attempt_ascent(input_dir)

	
func check_climb():
	if is_on_wall() and climb_flip != 3:
		var collision_count = get_slide_collision_count()
		var x: int = 0
		climb_side = "none"
		while x < collision_count:
			var collision = get_slide_collision(x)
			var collider = collision.get_collider()
			# was crashing when collider was NPC in process of dying
			if !is_instance_valid(collider): return
			var collider_name = collider.name
			
			if collider_name == "climbable":
				var distance = global_position.x - collision.get_position().x
				if distance > 0:
					climb_side = "left"
				else:
					climb_side = "right"
			x = x + 1
		if climb_side == "right":
			climb_flip = 1
		elif climb_side == "left":
			climb_flip = -1
		else:
			climb_flip = 0
	else:
		climb_flip = 0
	
	if is_on_ceiling() and climb_flip != 3:
		var collision_count = get_slide_collision_count()
		var x: int = 0
		climb_side = "none"
		while x < collision_count:
			var collision = get_slide_collision(x)
			var collider = collision.get_collider()
			# was crashing when collider was NPC in process of dying
			if !is_instance_valid(collider): return
			var collider_name = collider.name
			#thank you xRae! This printout was very useful. (plex)
			#print("player collision with " , collider_name, collider)
			if collider_name == "climbable":
				climb_side = "top"
				animated_sprite.flip_v = true
			x = x + 1
	elif !is_on_ceiling():
		climb_side = "none"
		animated_sprite.flip_v = false
		
		
func handle_dash():
	if Input.is_action_just_pressed("dash") and !dashing and !on_dash_cooldown and dash_usable:
		var direction = -1
		if animated_sprite.flip_h:
			direction = 1
		velocity.x = direction * SPEED * 5
		velocity.y = 0
		dashing = true
		dash_timer.start()
		dash_usable = false
	if dash_timer.is_stopped() and dashing:
		velocity.x = velocity.x/5
		dash_cooldown.start()
		dashing = false
		on_dash_cooldown = true
	if on_dash_cooldown and dash_cooldown.is_stopped():
		on_dash_cooldown = false
		
func animate():
	previous_animation_state = animation_state
	if input_dir > 0:
		animated_sprite.flip_h = true
	elif input_dir < 0:
		animated_sprite.flip_h = false
	if is_on_floor():
		if input_dir != 0:
			if !is_on_wall():
				if previous_animation_state == "Idle":
					animation_state = "Run_Start"
				else:
					if previous_animation_state != "Run_Start" || (previous_animation_state == "Run_Start" and animated_sprite.frame == animated_sprite.get_sprite_frames().get_frame_count("Run_Start") - 1):
						animation_state = "Run"
			else:
				animation_state = "Push"
		else:
			if previous_animation_state == "Run":
				animation_state = "Stop"
			elif previous_animation_state == "Stop" and animated_sprite.frame == animated_sprite.get_sprite_frames().get_frame_count("Stop") - 1:
				animation_state = "Idle"
			if previous_animation_state != "Run" and previous_animation_state != "Stop":
				animation_state = "Idle"
	else:
		if previous_animation_state != "Jump_Start" || (previous_animation_state == "Jump_Start" and animated_sprite.frame == animated_sprite.get_sprite_frames().get_frame_count("Jump_Start") - 1):
			if previous_animation_state != "Fall" and previous_animation_state != "Fall_Start":
				animation_state = "Fall_Start"
			elif previous_animation_state != "Fall_Start" || (previous_animation_state == "Fall_Start" and animated_sprite.frame == animated_sprite.get_sprite_frames().get_frame_count("Fall_Start") - 1):
				animation_state = "Fall"
	if jumping and previous_animation_state != "Jump_Start":
		animation_state = "Jump_Start"
	animated_sprite.play(animation_state)
	jumping = false
	


func play_audio():
	if animation_state == "Run":
		var frame = animated_sprite.get_frame()
		if frame != previous_animation_frame:
			if $AnimatedSprite3D.get_frame() in [ 0, 2, 4 ]:
				$Audio/Footsteps.play_random_noise()
	elif previous_animation_state == "Fall" and animation_state != "Fall": # landed
		$Audio/Landing.play_random_noise()
	elif animation_state == "Jump_Start":
		$Audio/Jumping.play_random_noise()
		

func set_gravity_states(delta):
	was_on_floor = is_on_floor()
	if not is_on_floor() and !dashing and !on_dash_cooldown and climb_flip == 0 and climb_side != "top":
		velocity.y += get_gravity() * delta

func update_gravity_states():
	if was_on_floor and !is_on_floor():
		coyote_time.start()
	if !was_on_floor and is_on_floor():
		double_jump = false
	if is_on_floor():
		dash_usable = true
		
func handle_jump():
	#On floor or coyote time
	if !Input.is_action_just_pressed("jump"):
		return
	if climb_flip == 0 and climb_side != "top":
		if (is_on_floor() || !coyote_time.is_stopped()):
			jump()
		#In air no coyote time with double
		elif !is_on_floor() and coyote_time.is_stopped() and !double_jump:
			jump()
			double_jump = true
		#In air no coyote time no double
		elif !is_on_floor() and coyote_time.is_stopped() and double_jump:
			buffered_jump = true
			jump_buffer.start()
		#On floor with buffered jump
		elif is_on_floor() and buffered_jump:
			jump()
			buffered_jump = false
	elif climb_flip == -1:
		velocity.y = jump_velocity
		velocity.x = jump_velocity * 2
		climb_flip = 3
		double_jump = false
		jumping = true
	elif climb_flip == 1:
		velocity.y = jump_velocity
		velocity.x = -jump_velocity * 2
		climb_flip = 3
		double_jump = false
		jumping = true
	elif climb_side == "top":
		climb_side = "none"
		velocity.y = -1
		animated_sprite.flip_v = false

func move():
	var fall_modifier = abs(clamp(velocity.y, -1.2, -1))
	input_dir = Input.get_axis("move_left", "move_right")
	var direction = (transform.basis * Vector3(input_dir, 0, 0)).normalized()
	if climb_flip == 0:
		if input_dir != 0:
			velocity.x = direction.x * SPEED * fall_modifier
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED/5 * fall_modifier)
	elif climb_flip == 3:
		if !is_on_wall():
			climb_flip = 0
	elif climb_flip !=3 and climb_flip !=0:
		velocity.y = direction.x * SPEED * climb_flip
		if is_on_floor() and velocity.y < 0:
			velocity.x = direction.x * SPEED * fall_modifier

func receive_knockback(impactVector):
	
	if Global.player_stats["health"] > 0:
		last_knockback_time = Time.get_ticks_msec()
		var knockback_magnitude = 10.0
		state = States.KNOCKBACK
		velocity.x = impactVector.normalized().x * knockback_magnitude
		velocity.y = 10.0
		move_and_slide()

func execute_knockback(delta):
	set_gravity_states(delta)
	move_and_slide()
	if Time.get_ticks_msec() > last_knockback_time + knockback_duration:
		if is_on_floor() or is_on_ceiling() or is_on_wall():
			if Global.player_stats["health"] > 0:
				state = States.READY
			else:
				state = States.DYING
			
	

func move_noclip(delta):
	
	velocity = Vector3( Input.get_axis("move_left", "move_right"), Input.get_axis("move_down", "move_up"), 0) * noclip_speed * delta
	

func get_gravity() -> float:
	return jump_gravity if velocity.y > 0.0 else fall_gravity

func jump():
	velocity.y = jump_velocity
	jumping = true

func _on_jump_buffer_timeout():
	buffered_jump = false

func _on_hit(damage, impactVector):
	if state in [ States.READY ]: # knockback gives iframes
		$Audio/Hurt.start()
		receive_knockback(impactVector)
		Global.player_stats["health"] -= damage
		$HUD._on_hit()

		if Global.player_stats["health"] < 1:
			begin_dying()
	
func begin_dying():
	Global.reset_player()
	StageManager.change_scene_to_file("res://Menus/death_screen.tscn")
