extends Node3D

@export var target : Vector3
@export var speed : int
@export var needs_activation = false

var tween

@onready var startPos = global_position
@onready var distance = (startPos + target * scale).distance_to(global_position)


# Called when the node enters the scene tree for the first time.
func _ready():
	startPos = global_position
	setup_tween()
	
func setup_tween():
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
	if needs_activation:
		setup_tween()
		tween.play()

func _on_switch_toggled(pressed):
	if needs_activation:
		_on_switch_hit()

func _on_plate_press(pressed):
	if needs_activation:
		tween.kill()
		tween = get_tree().create_tween()
		if pressed:
			tween.tween_property($StaticBody3D,"global_position",startPos + (target * scale), speed * dist_to_perc())
			print("moving platform dist_to_perc() == ", dist_to_perc())
		else:
			tween.tween_property($StaticBody3D, "global_position", startPos, speed * abs(dist_to_perc()-1))
			print("moving platform dist_to_perc() == ", dist_to_perc())

func dist_to_perc():
	return (startPos + target * scale).distance_to($StaticBody3D.global_position)/distance

