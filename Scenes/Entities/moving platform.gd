extends Node3D

@export var target : Vector3
@export var speed : int
@export var needs_activation = false

@onready 

var tween

# Called when the node enters the scene tree for the first time.
func _ready():
	var startPos = global_position
	tween = get_tree().create_tween()
	tween.set_ease(tween.EASE_IN_OUT)
	tween.tween_property($StaticBody3D,"global_position",startPos + (target * scale), speed)
	tween.tween_property($StaticBody3D, "global_position", startPos, speed)
	tween.set_loops()
	if needs_activation:
		tween.pause()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_child_exiting_tree(_node):
	tween.kill()

func _on_switch_hit():
	tween.play()
