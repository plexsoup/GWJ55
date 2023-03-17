extends Area3D


@onready var timer = $timeout
@onready var label = $Panel


var is_in_area = false;

func _on_timed_text_area_body_exited(body):
	is_in_area = false;
	
func _on_timed_text_area_body_entered(body):
	is_in_area = true;
	timer.start()

# attempts to call function is_visible in base null instance
func _on_timer_timeout():
	if(is_in_area):
		print("player is still in area")
		$AnimationPlayer.play('appear')
		await $AnimationPlayer.animation_finished
		print("now done animation")
		$AnimationPlayer.play_backwards('appear')
	else:
		print("player left area before check")
