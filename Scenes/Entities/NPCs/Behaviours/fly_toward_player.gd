extends BaseNPCBehaviour

@onready var raycast = $RayCast3D

var player_sighted : bool = false

signal saw_player(playerObj, originator)

func _ready():
	super._ready()
	

func init(entityObj):
	if active:
		super.init(entityObj)
		if entity.has_node("AnimationPlayer") and entity.get_node("AnimationPlayer").has_animation("fly"):
			entity.get_node("AnimationPlayer").play("fly")
		
		if entity.has_method("_on_player_sighted"):
			saw_player.connect(entity._on_player_sighted)

func update_input_controller():
	if !active: return
	
	elif player_sighted: # fly toward player
		var direction = Global.current_player.global_position - entity.global_position
		entity.input_controller.press_stick_toward(direction)
	
	
	else: # look for player
		raycast.look_at(Global.current_player.global_position)
		
		if raycast.is_colliding():
			var body = raycast.get_collider()
			
			if "player" in body.name.to_lower():
				print("FlyTowardPlayer sighted player with raycast")
				player_sighted = true
				saw_player.emit(body, self) # tell the entity
	
	

		
func _on_entity_sighted_player():
	state = States.PLAYING
