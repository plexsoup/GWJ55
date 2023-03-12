extends BaseNPCBehaviour

var leaping : bool = false
@onready var raycasts = [ $raycast_left, $raycast_right ]

signal hit

func _ready():
	super._ready()
	if not active:
		hide()
		queue_free()
		

func _process(delta):
	super._process(delta)
	


func update_input_controller():
	# once per polling interval
	if !active or entity == null:
		return

	elif leaping:
		
		if entity.is_on_floor():
			
			entity.input_controller.release_all_keys()
			entity.input_controller.release_key("jump")
			leaping = false

	else:
		for raycast in raycasts:
			if raycast.is_colliding(): # jump
				var directionName = "move_right"
				if raycast.get_collision_point().x < entity.global_position.x:
					directionName = "move_left"
				entity.input_controller.press_key(directionName)
				entity.input_controller.press_key("jump")
				leaping = true


func explode_violently():
	
	$CPUParticles3D.emitting = true
	await get_tree().create_timer(.5).timeout
	die()

func die():
	if entity.has_method("die"):
		entity.die()
	else:
		entity.queue_free()

func _on_hurt_box_body_entered(body):
	if "player" in body.name.to_lower():
		if body.has_method("_on_hit"):
			if not hit.is_connected(body._on_hit):
				hit.connect(body._on_hit)
			hit.emit(1)
			explode_violently()




