extends Control

signal finished

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func play_fade_out(): # from transparent to opaque
	#$AnimationPlayer.play("fade_out")
	$AnimationPlayer.play("fog_fade_out")
	
func play_fade_in(): # go to transparent, then queue_free()
	$AnimationPlayer.play("fog_fade_in")
	
	


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fog_fade_out":
		finished.emit()
	elif anim_name == "fog_fade_in":
		pass
