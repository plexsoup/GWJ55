extends BaseNPCBehaviour

func _ready():
	super._ready()
	

func init(entityObj):
	super.init(entityObj)
	if entity.has_node("AnimationPlayer") and entity.get_node("AnimationPlayer").has_animation("fly"):
		entity.get_node("AnimationPlayer").play("fly")


func update_input_controller():
	pass
	
