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

var knockback_magnitude : float = 1.0
var knockback_time : float
var knockback_duration : float = 750 #ms
var knockback_angular_velocity: float = 0.3

var delay_after_attack : float = 2250 # ms
var time_of_last_attack : float = 0.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var current_map



@onready var input_controller = $VirtualInputController

enum States { READY, KNOCKBACK, PAUSED, DYING, DEAD }
var state = States.READY

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
	
	if state == States.READY:
		move(delta)
		orient_mesh(delta)
	elif state == States.KNOCKBACK:
		get_knocked_back(delta)
	elif state == States.PAUSED:
		if Time.get_ticks_msec() > time_of_last_attack + delay_after_attack:
			resume()
		
func resume():
	if has_node("RunningSound"):
		$RunningSound.play()
	state = States.READY



func get_knocked_back(delta):
	apply_gravity(delta)
	move_and_slide()
	if Time.get_ticks_msec() > knockback_time + knockback_duration:
		if is_on_ceiling() or is_on_floor() or is_on_wall():
			$ThunkSound.start()
			begin_dying()
	rotate_z(knockback_angular_velocity * delta)

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
	if state in [ States.READY ]:
		if "player" in body.name.to_lower():
			if not hit.is_connected(body._on_hit) and body.has_method("_on_hit"):
				hit.connect(body._on_hit)
			hit.emit(damage, body.global_position - global_position)
			state = States.PAUSED
			if has_node("RunningSound"):
				$RunningSound.stop()
			time_of_last_attack = Time.get_ticks_msec()


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
	state = States.DYING
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
		
func knockback(impactVector):
	state = States.KNOCKBACK
	
	knockback_angular_velocity = randf_range(8.0, 20.0)
	if randf()<0.5 : knockback_angular_velocity *= -1.0
	
	velocity = Vector3.ZERO
	velocity.x = impactVector.x * knockback_magnitude
	velocity.y = JUMP_VELOCITY
	
	if impactVector.x < 0:
		velocity.x *= -1
	
	# disable collisions with player
	set_collision_layer_value(2, false)
	set_collision_mask_value(1, false)
	#print("irritating how empty lines are ignored for breakpoints")
	self.move_and_slide()
	knockback_time = Time.get_ticks_msec()


func _on_weak_spot_body_entered(body):
	if not state in [States.READY, States.PAUSED]:
		return
		
	if $Visuals/WeakSpot.monitoring and "player" in body.name.to_lower():
		$HurtSound.start()
		if has_node("RunningSound"):
			$RunningSound.stop()
		knockback(global_position - body.global_position)
		
func _on_electrocuted(): # from water
	if electrical:
		print("NPC death by electrocution, " + self.name)
		begin_dying()

