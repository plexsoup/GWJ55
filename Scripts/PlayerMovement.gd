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
var input_dir
var jumping = false
var dashing = false
var on_dash_cooldown = false
var dash_usable = true
var climb_side = "none"
var climb_flip = 0

func _ready():
	Global.current_player = self

func _physics_process(delta):
	
	check_climb()	
	set_gravity_states(delta)
	handle_dash()
	if !dashing and !on_dash_cooldown:
		handle_jump()
		move()
	move_and_slide()
	update_gravity_states()
	animate()
	play_audio()

func wind_throw():
	pass

func throw():
	pass

func check_climb():
	if is_on_wall() and climb_flip != 3:
		var collision_count = get_slide_collision_count()
		var x: int = 0
		climb_side = "none"
		while x < collision_count:
			var collision = get_slide_collision(x)
			var collider = collision.get_collider()
			var collider_name = collider.name
			if collider.name == "climbable":
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
	var previous_animation_state = animation_state
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
		if $AnimatedSprite3D.get_frame() in [ 0, 2, 4 ]:
			$Footsteps.play_random_noise()

func set_gravity_states(delta):
	was_on_floor = is_on_floor()
	if not is_on_floor() and !dashing and !on_dash_cooldown and climb_flip == 0:
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
	if climb_flip == 0:
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

func get_gravity() -> float:
	return jump_gravity if velocity.y > 0.0 else fall_gravity

func jump():
	velocity.y = jump_velocity
	jumping = true

func _on_jump_buffer_timeout():
	buffered_jump = false

func _on_hit(damage):
	Global.player_stats["health"] -= damage
	$HUD._on_hit()

	if Global.player_stats["health"] < 1:
		begin_dying()
	
func begin_dying():
	Global.reset_player()
	StageManager.change_scene_to_file("res://Menus/death_screen.tscn")
