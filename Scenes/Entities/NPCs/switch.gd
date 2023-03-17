extends Node3D
signal switch_hit(value)

@export var pressed : bool = false
@export var target_node : NodePath
@export var single_use : bool = true # most switches just stay on?

var target

# Called when the node enters the scene tree for the first time.
func _ready():
	if not target_node.is_empty():
		target = get_node(target_node)
		switch_hit.connect(target._on_switch_toggled)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_area_3d_body_entered(body):
	if "player" in body.name.to_lower():
		if !pressed or !single_use:
			pressed = !pressed
			rotate_lever()
			emit_signal("switch_hit", pressed)
		
func rotate_lever():
	$ClickNoise.play()
	if pressed:
		$Hinge.rotate_z(-PI/2.0)
	else:
		$Hinge.rotate_z(PI/2.0)

