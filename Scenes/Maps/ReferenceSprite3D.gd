extends Sprite3D

@export var hide_in_game : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	if hide_in_game:
		hide()


