extends Node3D
signal switch_hit(value)

@export var pressed : bool = false
@export var target_node : NodePath
@export var single_use : bool = true # most switches just stay on?

enum Functions { OPEN, CLOSE, TOGGLE, ACTIVATE, DESTROY }
@export var function : Functions = Functions.TOGGLE


var target

# Called when the node enters the scene tree for the first time.
func _ready():
	if not target_node.is_empty():
		target = get_node(target_node)
		if target.has_method("_on_switch_toggled"):
			switch_hit.connect(target._on_switch_toggled)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_area_3d_body_entered(body):
	if "player" in body.name.to_lower():
		if !pressed or !single_use:
			pressed = !pressed
			rotate_lever()
			if function in [ Functions.ACTIVATE, Functions.TOGGLE, Functions.OPEN, Functions.CLOSE ]:
				emit_signal("switch_hit", pressed)
			elif function == Functions.DESTROY: # hack to just get rid of some problematic puzzle elements
				target.queue_free()
		
func rotate_lever():
	$ClickNoise.play()
	if pressed:
		$Hinge.rotate_z(-PI/2.0)
	else:
		$Hinge.rotate_z(PI/2.0)

