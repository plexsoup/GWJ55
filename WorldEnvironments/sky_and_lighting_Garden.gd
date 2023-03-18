@tool

extends WorldEnvironment
@export var low_spec_in_editor : bool = true : set = set_low_spec, get = get_low_spec


# Called when the node enters the scene tree for the first time.
func _ready():
	if Engine.is_editor_hint():
		if low_spec_in_editor:
			set_environment(load("res://Shaders/World_Aesthics_low_spec.tres"))
		else: # high_spec
			set_environment(load("res://Shaders/Garden_Aesthic.tres"))
	else: # running in-game
		if Global.low_spec == false:
			set_environment(load("res://Shaders/Garden_Aesthic.tres"))
		else:
			set_environment(load("res://Shaders/World_Aesthics_low_spec.tres"))


func change_graphics_settings():
	set_low_spec(Global.low_spec)
	
func set_low_spec(value : bool):
	if value == true:
		set_environment(load("res://Shaders/World_Aesthics_low_spec.tres"))
	else:
		set_environment(load("res://Shaders/Garden_Aesthic.tres"))

	low_spec_in_editor = value
	
func get_low_spec():
	return low_spec_in_editor
