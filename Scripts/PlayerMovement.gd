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


const SPEED = 10.0
var buffered_jump = false

func _physics_process(delta):
	
	var was_on_floor = is_on_floor()
	if not is_on_floor():
		velocity.y += get_gravity() * delta
		
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() || !coyote_time.is_stopped()):
		jump()
	elif Input.is_action_just_pressed("jump") and (!is_on_floor() || coyote_time.is_stopped()):
		buffered_jump = true
		jump_buffer.start()
	elif is_on_floor() and buffered_jump:
		jump()
		buffered_jump = false
	
	#Move
	
	var input_dir
	if inverted_x:
		input_dir = Input.get_axis("move_right", "move_left")
	else:
		input_dir = Input.get_axis("move_left", "move_right")
	var direction = (transform.basis * Vector3(input_dir, 0, 0)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	if was_on_floor and !is_on_floor():
		coyote_time.start()

func get_gravity() -> float:
	return jump_gravity if velocity.y > 0.0 else fall_gravity

func jump():
	velocity.y = jump_velocity

func _on_jump_buffer_timeout():
	buffered_jump = false
