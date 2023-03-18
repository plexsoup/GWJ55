extends Node3D

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(0.25).timeout
	player = Global.current_player



func attempt_ascent(x_direction : int):
	var magnitude = 1.5
	$UpperRayCast.target_position = Vector3.RIGHT * x_direction * magnitude
	if player.is_on_wall():
		if $UpperRayCast.is_colliding(): # hit a platform (on layer 3)
			return
		else: # no obstacle, you can ascend
			if abs(player.velocity.y) < 0.05: # approximately zero
				Global.current_player.velocity.y += player.jump_velocity*0.67
		
