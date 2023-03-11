# Base class for defining NPC AI

# Currently just calls update_input_controller() at a specified polling interval.


extends Node3D
class_name BaseNPCBehaviour


@export var active : bool = false

var entity : CharacterBody3D

var current_direction : Vector3 = Vector3.LEFT
var speed : float = 20.0

var last_poll_time : int = 0 #msec
@export var polling_interval : int = 100 #msec

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(entityObj):
	entity = entityObj

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if active and entity != null and is_instance_valid(entity):
		var ticks = Time.get_ticks_msec()
		if ticks > last_poll_time + polling_interval:
			last_poll_time = ticks
			
			self.update_input_controller()

func update_input_controller():
	# override this in subclasses
	pass
