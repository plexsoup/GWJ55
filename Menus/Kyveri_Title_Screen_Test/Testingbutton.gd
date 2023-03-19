extends Button

var toggle = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _pressed():
	Global.low_spec = true
	StageManager.change_scene_to_file("res://Scenes/Maps/Official/LivingRoom/LivingRoom.tscn")
	
	#$"../../Testing".visible = true


	
