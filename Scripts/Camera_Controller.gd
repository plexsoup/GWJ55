extends Camera3D

@onready var target = $".."
@onready var bounding_box = $Area3D
@onready var collision_shape = $Area3D/CollisionShape3D
@onready var sprite = $"../AnimatedSprite3D"

@export var lerp_speed = 3.0

@export var desired_camera_offset = 15.0

var follow = false
var starting_position : Vector3
var starting_fov : float

var found_player : bool = false

var free_jump_taken : bool = false

func _ready():
	top_level = true
	starting_position = position
	starting_fov = fov
	
	# Trying to figure out why the camera won't center on the player when the player gets moved to a spawnpoint.
	
#	# workaround spawn point bug, player moves immediately after level starts
#	await get_tree().create_timer(0.25).timeout
#	global_position.x = Global.current_player.global_position.x
#	global_position.y = Global.current_player.global_position.y
#	follow = true
#	found_player = true

func _physics_process(delta):
	if Global.current_player != null:
		global_position = Global.current_player.global_position + Vector3.BACK * desired_camera_offset

	if follow:
		#Follow
		var target_pos = target.global_position
		var lerp_x = lerp(global_position.x, target_pos.x, lerp_speed*2 * delta)
		global_position.x = lerp_x
		
		#Look Ahead
		var x_distance_from_player = global_position.x - target_pos.x
		var target_x_offset = -x_distance_from_player * 3
		var lerpX = lerp(h_offset, target_x_offset, lerp_speed * delta)
		h_offset = lerpX
	var y = lerp(global_position.y, target.global_position.y, lerp_speed * 10 * delta)
	global_position.y = y
		
func _on_area_3d_body_exited(body):
	
	if body == target:
		follow = true

func _on_area_3d_body_entered(body):
	if body == target:
		follow = false

func zoom_in():
	position = starting_position
	fov = starting_fov

func zoom_out():
	position = starting_position + (Vector3.BACK * 100.0)
	fov = starting_fov / 2.0


func _unhandled_input(_event):
	# secret debugging keystrokes ( + / - )
	if Input.is_action_just_pressed("zoom_in"):
		zoom_in()
	elif Input.is_action_just_pressed("zoom_out"):
		zoom_out()
