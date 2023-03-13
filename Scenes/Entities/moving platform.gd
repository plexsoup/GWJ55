extends Node3D

@export var target : Vector3
@export var speed : int

@onready var animation_name = $AnimationPlayer.current_animation
@onready var animation = $AnimationPlayer.get_animation(animation_name)

@onready var track_name = animation.track_get_path(0)
@onready var track = animation.find_track(track_name, Animation.TYPE_POSITION_3D)



# Called when the node enters the scene tree for the first time.
func _ready():
	animation.length = speed;
	animation.position_track_insert_key(track, 0.0, Vector3(0, 0, 0))
	animation.position_track_insert_key(track, speed/2.5, target)
	animation.position_track_insert_key(track, speed, Vector3(0, 0, 0))
	$AnimationPlayer.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
