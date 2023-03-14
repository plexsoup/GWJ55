extends Node3D

@export var speed = 3.0

# Called when the node enters the scene tree for the first time.
func _ready():
	find_child("AnimationPlayer", true).speed_scale = randf_range(0.85, 1.15)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Path3D/PathFollow3D.progress += speed * delta
