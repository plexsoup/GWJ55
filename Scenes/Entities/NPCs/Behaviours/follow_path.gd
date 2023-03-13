extends BaseNPCBehaviour

## Description: PathFollow3D node
@export var path_to_follow : NodePath
@export var follow_speed : float = 15.0 # meters / second?
@export var stop_when_player_sighted : bool = true

var path : Path3D
var path_follower : PathFollow3D

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()

		

func init(entityObj : CharacterBody3D):
	if active:
		super.init(entityObj)
		if entity.path_to_follow != null and !entity.path_to_follow.is_empty(): # should be in the NPC base parameters
			path_to_follow = entity.path_to_follow
			path = get_node(path_to_follow)

		elif path_to_follow != null and !path_to_follow.is_empty(): # maybe someone put it on the behaviour node instead of the NPC root node
			path_to_follow = path_to_follow
			path = get_node(path_to_follow)

		else:
			#printerr(self.name, " needs a path_to_follow. Making one from template")
			make_a_path()
		
		setup_path_follower()


func setup_path_follower():
	path_follower = PathFollow3D.new()
	path.add_child(path_follower)
	path_follower.progress_ratio = 0.0
		

func make_a_path():
	var tempPath = $Path3DTemplate
	var tempPosition = tempPath.global_position
	remove_child(tempPath)
	entity.get_parent().add_child(tempPath)
	tempPath.global_position = tempPosition
	path = tempPath


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !active: 
		return
	else:
		super._process(delta)

		if path_follower != null and is_instance_valid(path_follower):
			path_follower.progress += follow_speed * delta
			#entity.global_position = lerp(entity.global_position, path_follower.global_position, 0.8)
	
func update_input_controller():
	var direction = path_follower.global_position - entity.global_position
	entity.input_controller.press_stick_toward(direction)
	#pass
	
func _on_entity_sighted_player():
	if stop_when_player_sighted:
		active = false
