extends Area3D


@onready var timer = $timeout
@onready var label = $Panel

@export_multiline var text_to_display : String = "WASD Move, Space jump"

var is_in_area = false;

func _ready():
	$Panel/Text.text = text_to_display

# TimedTextArea body_exited -> _on_timed_text_area_body_exited
func _on_timed_text_area_body_exited(body):
	is_in_area = false;
	
# Area2d(TimedTextArea) body_entered -> _on_timed_text_area_body_entered
func _on_timed_text_area_body_entered(body):
	is_in_area = true;
	timer.start()

# Timer(timeout) timeout -> _on_timer_timeout
func _on_timer_timeout():
	if(is_in_area):
		print("player is still in area")
		$AnimationPlayer.play('appear')
		await $AnimationPlayer.animation_finished
		print("now done animation")
		$AnimationPlayer.play_backwards('appear')
	else:
		print("player left area before check")
