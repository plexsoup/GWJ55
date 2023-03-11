extends BaseNPCBehaviour

# note, if you override _process() or _ready(), you'll lose that behaviour from the superclass.

func _ready():
	super._ready()
	if not active:
		hide()
		queue_free()
		

func _process(delta):
	super._process(delta)
	




func update_input_controller():
	if active and entity != null and is_instance_valid(entity):
		# once per polling interval
		if $RayCast3D.is_colliding():
			entity.input_controller.move_right = 1.0
			entity.input_controller.jump = true
			entity.input_controller.actions_just_pressed["jump"] = true
