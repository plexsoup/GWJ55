extends MeshInstance3D

@export var is_water : bool = true

signal hit
signal electrocute


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_area_3d_body_entered(body):
	print("deadly tile hit")
	if "player" in body.name.to_lower():
			print("player hit deadly tile")
			if not hit.is_connected(body._on_hit):
				hit.connect(body._on_hit)
			hit.emit(1)
			StageManager.reset_level()
	elif "dryer" in body.name.to_lower():
		if body.has_method("_on_electrocuted"):
			if not electrocute.is_connected(body._on_electrocuted):
				electrocute.connect(body._on_electrocuted)
			electrocute.emit()
			electrocute.disconnect(body._on_electrocuted)
