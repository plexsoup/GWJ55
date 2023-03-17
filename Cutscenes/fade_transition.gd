extends Control

signal finished

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func fade_out(): # from transparent to opaque
	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished
	finished.emit()

func fade_in(): # go to transparent, then queue_free()
	$AnimationPlayer.play("fade_in")
	# note animation includes a call to queue_free()
	

