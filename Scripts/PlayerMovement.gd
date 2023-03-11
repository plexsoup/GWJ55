extends CharacterBody3D

@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float
@export var inverted_x : bool = true

@onready var jump_velocity : float = (2.0 * jump_height) / jump_time_to_peak
@onready var jump_gravity : float = (-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)
@onready var fall_gravity : float = (-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)
@onready var coyote_time = $CoyoteTime
@onready var jump_buffer = $JumpBuffer
@onready var animated_sprite = $AnimatedSprite3D

const SPEED = 10.0
var buffered_jump = false
var was_on_floor
var double_jump = false
var animation_state = "Idle"
var input_dir
var jumping = false

func _ready():
	Global.current_player = self

func _physics_process(delta):

	set_gravity_states(delta)
	handle_jump()
	move()
	move_and_slide()
	update_gravity_states()
	animate()
	
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
					if previous_animation_state != "Run_Start" || (previous_animation_state == "Run_Start" and animated_sprite.frame == 2):
						animation_state = "Run"
			else:
				animation_state = "Push"
		else:
			animation_state = "Idle"
	else:
		if previous_animation_state != "Jump_Start" || (previous_animation_state == "Jump_Start" and animated_sprite.frame == 2):
			if previous_animation_state != "Fall" and previous_animation_state != "Fall_Start":
				animation_state = "Fall_Start"
			elif previous_animation_state != "Fall_Start" || (previous_animation_state == "Fall_Start" and animated_sprite.frame == 2):
				animation_state = "Fall"
	if jumping and previous_animation_state != "Jump_Start":
		animation_state = "Jump_Start"
	animated_sprite.play(animation_state)
	jumping = false

func set_gravity_states(delta):
	was_on_floor = is_on_floor()
	if not is_on_floor():
		velocity.y += get_gravity() * delta

func update_gravity_states():
	if was_on_floor and !is_on_floor():
		coyote_time.start()
	if !was_on_floor and is_on_floor():
		double_jump = false
		
func handle_jump():
	#On floor or coyote time
	if Input.is_action_just_pressed("jump") and (is_on_floor() || !coyote_time.is_stopped()):
		jump()
	#In air no coyote time with double
	elif Input.is_action_just_pressed("jump") and !is_on_floor() and coyote_time.is_stopped() and !double_jump:
		jump()
		double_jump = true
	#In air no coyote time no double
	elif Input.is_action_just_pressed("jump") and !is_on_floor() and coyote_time.is_stopped() and double_jump:
		buffered_jump = true
		jump_buffer.start()
	#On floor with buffered jump
	elif is_on_floor() and buffered_jump:
		jump()
		buffered_jump = false

func move():
	if inverted_x:
		input_dir = Input.get_axis("move_right", "move_left")
	else:
		input_dir = Input.get_axis("move_left", "move_right")
	var direction = (transform.basis * Vector3(input_dir, 0, 0)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

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
