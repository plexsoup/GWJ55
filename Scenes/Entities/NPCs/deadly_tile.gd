extends MeshInstance3D

@export var is_water : bool = true

signal hit
signal electrocute

var hit_player_count : int = 0
@export var max_player_hits : int = 1

@export var reset_level_on_max_hits : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	_low_spec()


func _on_area_3d_body_entered(body):
	print("deadly tile hit")
	if "player" in body.name.to_lower():
		if hit_player_count < max_player_hits:
			hit_player_count += 1
			print("player hit deadly tile")
			if not hit.is_connected(body._on_hit):
				hit.connect(body._on_hit)
			hit.emit(1, Vector3(0, 10, 0))
			$SplashNoise.start()
			$CPUParticles3D.emitting = true
		else:
			await get_tree().create_timer(1.5).timeout
			if reset_level_on_max_hits:
				StageManager.reset_level()

	elif "dryer" in body.name.to_lower():
		if body.has_method("_on_electrocuted"):
			if not electrocute.is_connected(body._on_electrocuted):
				electrocute.connect(body._on_electrocuted)
			electrocute.emit()
			electrocute.disconnect(body._on_electrocuted)

func _low_spec():
	if Global.low_spec == false:
		$AnimationPlayer.play("High_Spec")
	else :
		$AnimationPlayer.play("Low_spec")
	
		
		
	

