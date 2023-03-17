extends Node3D

@export var frequency : float = 500.0
@export var magnitude : float = PI/22.0
# Called when the node enters the scene tree for the first time.
func _ready():
	frequency *= randf_range(0.8, 1.25)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.current_player != null:
		var time = Time.get_ticks_msec()
		
		self.look_at(Global.current_player.global_position)
		self.rotate_y((sin(float(time)/frequency)-0.5) * magnitude)
		self.rotate_z((sin(float(time)/frequency)-0.5) * magnitude)
		
