extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _pressed():
	$"../../Camera3D/AnimationPlayer2".play("Camera_Dive")
	$"../AnimationPlayer".play("Slide_Play")
