extends Node

var move_left : float = 0.0
var move_right : float = 0.0

# not required for a 2.0D game, even with 3d actors.
var move_up : float = 0.0
var move_down : float = 0.0

var jump : bool = false
var actions_pressed = {
	"jump":false,
	"move_left":false,
	"move_right":false,
	"move_up":false,
	"move_down":false
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.





func get_vector(_negX, _posX, _negY, _posY):
	var resultVector = Vector3.ZERO
	resultVector += Vector3.LEFT * move_left
	resultVector += Vector3.RIGHT * move_right
	resultVector += Vector3.UP * move_up
	resultVector += Vector3.DOWN * move_down
	return resultVector

