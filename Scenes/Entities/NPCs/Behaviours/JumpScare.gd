extends BaseNPCBehaviour


# Called when the node enters the scene tree for the first time.
func _ready():
	if not active:
		hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# once per frame
	pass

func update_input_controller():
	
	if active and entity != null and is_instance_valid(entity):
		# once per polling interval
		print("hair dryer polled")

		if $RayCast3D.is_colliding():
			print("jumpscare")
			entity.input_controller.move_right = 1.0
			entity.input_controller.jump = true
			entity.input_controller.actions_just_pressed["jump"] = true
