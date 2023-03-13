extends Node

var move_left : float = 0.0
var move_right : float = 0.0

# not required for a 2.0D game, even with 3d actors.
var move_up : float = 0.0
var move_down : float = 0.0

var jump : bool = false
var actions_just_pressed = {
	"jump":false,
	"move_left":false,
	"move_right":false,
	"move_up":false,
	"move_down":false,
}

var actions_pressed = {
	"jump":false,
	"move_left":false,
	"move_right":false,
	"move_up":false,
	"move_down":false,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func get_vector(_negX, _posX, _negY, _posY):
	var resultVector = Vector3.ZERO
	resultVector += Vector3.LEFT * get(_negX)
	resultVector += Vector3.RIGHT * get(_posX)
	resultVector += Vector3.UP * get(_posY)
	resultVector += Vector3.DOWN * get(_negY)
	return resultVector


func is_action_just_pressed(actionName):
	# for jumping or whatever
	if actions_just_pressed[actionName] == true:
		# reset the action and report
		actions_just_pressed[actionName] = false
		return true
	else:
		return false
	
	
func press_key(actionName):
	actions_pressed[actionName] = true
	actions_just_pressed[actionName] = true
	if "move" in actionName:
		set(actionName, 1.0)
	
func release_key(actionName):
	actions_pressed[actionName] = false
	if "move" in actionName:
		set(actionName, 0.0)

func release_all_keys():
	for actionName in actions_pressed.keys():
		actions_pressed[actionName] = false
	for actionName in actions_just_pressed.keys():
		actions_just_pressed[actionName] = false
	move_left = 0.0
	move_right = 0.0
	move_down = 0.0
	move_up = 0.0
	
func press_stick_toward(direction):
	var dead_zone = 0.01
	direction = direction.normalized()

	release_all_keys()

	if direction.x < -dead_zone:
		move_left = -direction.x
		actions_pressed["move_left"] = true
	elif direction.x > dead_zone:
		move_right = direction.x
		actions_pressed["move_right"] = true
	if direction.y <- dead_zone:
		move_down = -direction.y
		actions_pressed["move_down"] = true
	elif direction.y > dead_zone:
		move_up = direction.y
		actions_pressed["move_up"] = true
		
