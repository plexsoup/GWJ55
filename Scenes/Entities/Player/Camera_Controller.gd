extends Camera3D

@onready var player = $".."

func _process(delta):
	var target_h_offset = lerp(h_offset, player.velocity.x, 0.2 * delta)
	h_offset = clamp(target_h_offset, -player.SPEED/2.2, player.SPEED/2.2)
