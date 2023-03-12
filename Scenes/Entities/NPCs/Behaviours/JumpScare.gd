extends BaseNPCBehaviour

var leaping : bool = false


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
		if $RayCast3D.is_colliding() and not leaping:
			#entity.input_controller.jump = true
			#entity.input_controller.actions_just_pressed["jump"] = true
			entity.input_controller.press_key("move_right")
			entity.input_controller.press_key("jump")
		elif leaping:
			if entity.is_on_ground():
				entity.input_controller.release_key("move_right")
				entity.input_controller.release_key("jump")
