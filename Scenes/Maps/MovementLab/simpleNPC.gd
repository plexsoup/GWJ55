extends CharacterBody3D
@onready var mesh = $Visuals/VaccuumMesh
@export var falls = true
@export var SPEED = 5.0
@export var direction = 1
var coyote_time = 0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor() and falls:
		velocity.y -= gravity * delta
	elif not is_on_floor() and !falls:
		global_position.x -= SPEED * direction * delta
		direction = -direction
		if coyote_time > 0.3:
			velocity.y -= gravity * delta
		coyote_time += delta
	elif is_on_floor():
		coyote_time = 0
	if is_on_wall():
		direction = -direction
	velocity.x = SPEED * direction
	move_and_slide()
	mesh.scale.x = direction
