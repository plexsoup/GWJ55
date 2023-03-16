extends MeshInstance3D

@export var time_interval : float = 18.0 # seconds
@export var speed : float = 5.0
var last_decision_time : float = 0.0
var direction : Vector3
var angular_speed : float = 0.2
var tumble_rotation : Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	choose_new_direction()
	time_interval *= randf_range(0.8, 1.2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var now = Time.get_ticks_msec()
	if now > last_decision_time + (time_interval * 1000):
		choose_new_direction()

	position += direction * delta * speed
	rotation += tumble_rotation * delta * angular_speed
	# TBD: it'd be nice to add some sin wave or lerp or something smooth

func get_rand_vector():
	var randX = randf_range(-1.0, 1.0)
	var randY = randf_range(-1.0, 1.0)
	var randZ = randf_range(-1.0, 1.0)
	var newVector = Vector3(randX, randY, randZ)
	newVector = (newVector + newVector.normalized())/2.0
	return newVector

func choose_new_direction():
	direction = get_rand_vector()
	tumble_rotation = get_rand_vector()
