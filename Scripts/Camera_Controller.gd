extends Camera3D

@onready var target = $".."
@onready var bounding_box = $Area3D
@onready var collision_shape = $Area3D/CollisionShape3D
@onready var sprite = $"../AnimatedSprite3D"

@export var lerp_speed = 3.0
@export var offset = Vector2.ZERO

var follow = false

func _ready():
	top_level = true

func _physics_process(delta):
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
