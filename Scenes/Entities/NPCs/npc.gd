extends CharacterBody3D


@export var SPEED = 4.5
@export var JUMP_VELOCITY = 10.0
@export var TURN_SPEED = PI / 16.0

@export var damage : int = 1
@export var flying : bool = false
@export var electrical : bool = false

@export var path_to_follow : NodePath
@export var animation_player_location : NodePath

@export var jump_off_cliffs : bool = false

var path : PathFollow3D


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

	if "dryer" in name:
		electrical = true

	if has_node("Behaviours/BackAndForth"):
		$Behaviours/BackAndForth.jump_off_cliffs = jump_off_cliffs

func _physics_process(delta):
	move(delta)
	orient_mesh(delta)


func move(delta):
	
	apply_gravity(delta)


	# Handle Jump.
	if input_controller.is_action_just_pressed("jump") == true and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction from the virtual controller and handle the movement/deceleration.
	var input_dir = input_controller.get_vector("move_left", "move_right", "move_down", "move_up")

	#var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var direction = (transform.basis * Vector3(input_dir.x, input_dir.y, 0)).normalized()

	# note the transform.basis never changes.
	# 	We're just reorienting the mesh.
	# 	This might change if we add ramps and stuff.

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		if flying:
			velocity.y = direction.y * SPEED
	else:
		pass
#		velocity.x = move_toward(velocity.x, 0, SPEED)
#		velocity.z = move_toward(velocity.z, 0, SPEED)
#		if flying:
#			velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()

func apply_gravity(delta):
	if not flying:
		var fake_gravity = gravity
		if velocity.y < 0 :
			fake_gravity *= 2.0 # fall faster than you jump
		if not is_on_floor():
			velocity.y -= fake_gravity * delta
		else: 
			velocity.y = 0.0


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


func _on_player_sighted(body, originator): 
	# one of the behaviours has notified us they saw the player.
	# tell the other behaviours, in case they need to change something.
	
	# for example, FollowPath might want to disable itself.
	
	if "player" in body.name.to_lower():
		for behaviour in $Behaviours.get_children():
			if behaviour != originator and behaviour.active:
				if behaviour.has_method("_on_entity_sighted_player"):
					behaviour._on_entity_sighted_player()
		

func begin_dying():
	# make a noise
	# play an animation
	# set a timer for queue_free
	var animation_player : AnimationPlayer = $DefaultAnimationPlayer
	if not animation_player_location.is_empty():
		animation_player = get_node(animation_player_location)

	if animation_player.has_animation("die"):
		animation_player.play("die")
		await animation_player.animation_finished
		queue_free()
	else:
		await get_tree().create_timer(0.5).timeout
		queue_free()
		
	

func _on_weak_spot_body_entered(body):
	if $Visuals/WeakSpot.monitoring and "player" in body.name.to_lower():
		$HurtSound.start()
		begin_dying()
		
func _on_electrocuted(): # from water
	if electrical:
		print("NPC death by electrocution, " + self.name)
		begin_dying()

