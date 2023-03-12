extends CharacterBody3D


@export var SPEED = 4.5
@export var JUMP_VELOCITY = 10.0
@export var TURN_SPEED = PI / 16.0

@export var damage : int = 1




# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var current_map



@onready var input_controller = $VirtualInputController

signal hit


func _ready():
	if Global.current_map != null:
		current_map = Global.current_map
	else: # current_map isn't ready yet.
		await get_tree().create_timer(0.25).timeout
		current_map = Global.current_map
	
	for behaviour in $Behaviours.get_children():
		if behaviour.has_method("init"):
			behaviour.init(self)


func _physics_process(delta):
	move(delta)
	orient_mesh(delta)


func move(delta):
	# Add the gravity.
	var fake_gravity = gravity
	if velocity.y < 0 :
		fake_gravity *= 2.0 # fall faster than you jump
	if not is_on_floor():
		velocity.y -= fake_gravity * delta
	else: 
		velocity.y = 0.0


	# Handle Jump.
	if input_controller.is_action_just_pressed("jump") == true and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction from the virtual controller and handle the movement/deceleration.
	var input_dir = input_controller.get_vector("move_left", "move_right", "move_up", "move_down")

	#var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var direction = (transform.basis * Vector3(input_dir.x, 0, 0)).normalized()

	# note the transform.basis never changes.
	# 	We're just reorienting the mesh.
	# 	This might change if we add ramps and stuff.

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()



func orient_mesh(_delta):
	var desired_y_rotation : float
	# temporarily flip the mesh using scale.x.
	# later, I'll probably add in smooth rotation around the y axis.
	var visuals = $Visuals
	if velocity.x > 0:
		#visuals.scale.x = abs(visuals.scale.x)
	
		desired_y_rotation = 0.0
	
		
	else:
		#visuals.scale.x = -abs(visuals.scale.x)

		desired_y_rotation = PI
	
	visuals.rotation.y = lerp(visuals.rotation.y, desired_y_rotation, TURN_SPEED)
	
	
	
	


func _on_hurtbox_body_entered(body):
	
	if "player" in body.name.to_lower():
		if not hit.is_connected(body._on_hit) and body.has_method("_on_hit"):
			hit.connect(body._on_hit)
		hit.emit(damage)

