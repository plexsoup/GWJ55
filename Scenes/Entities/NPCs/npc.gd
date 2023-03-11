extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

const TURN_SPEED = PI / 16.0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var current_map



@onready var input_controller = $VirtualInputController



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
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	
	var input_dir = input_controller.get_vector("move_left", "move_right", "move_up", "move_down")

	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	# note the transform.basis never changes, because it's a 2d platformer. we're just reorienting the mesh.
	

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()



func orient_mesh(delta):
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
	
	
	
	
