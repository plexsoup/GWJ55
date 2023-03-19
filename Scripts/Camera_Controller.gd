extends Camera3D

@onready var target = $".."
@onready var bounding_box = $Area3D
@onready var collision_shape = $Area3D/CollisionShape3D
@onready var sprite = $"../AnimatedSprite3D"

@export var lerp_speed = 3.0

@export var desired_camera_offset = 10.0

var follow = false
var starting_position : Vector3
var starting_fov : float
var previous_target_pos
var found_player : bool = false

var free_jump_taken : bool = false

func _ready():
	top_level = true
	starting_position = position
	starting_fov = fov
	previous_target_pos = target.global_position

func _physics_process(delta):
	var target_delta = previous_target_pos.distance_to(target.global_position)
	previous_target_pos = target.global_position
	if target_delta > 5:
		global_position.y = target.global_position.y
		global_position.x = target.global_position.x
	if follow:
		#Follow
		var target_pos = target.global_position
		var lerp_x = lerp(global_position.x, target_pos.x, lerp_speed*2 * delta)
		global_position.x = lerp_x
		
		#Look Ahead
		var x_distance_from_player = global_position.x - target_pos.x
		var target_x_offset = -x_distance_from_player * 2.211
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
