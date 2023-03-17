## Description: duplicate yourself, play clone, then clone destroys itself
extends AudioStreamPlayer3D

@export var pitch_jitter : float = 0.05

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func start():
	var newSound = self.duplicate()
	get_tree().get_root().add_child(newSound)
	newSound.set_global_position(self.get_global_position())
	newSound.finished.connect(newSound.queue_free)
	newSound.set_pitch_scale(randf_range(1.0-pitch_jitter, 1.0+pitch_jitter))
	newSound.play()

