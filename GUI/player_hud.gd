extends CanvasLayer

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent()
	_on_hit() # set the health bar.


func _on_hit():
	for lifeIcon in $Control/HealthBox.get_children():
		if lifeIcon.get_index() < Global.player_stats["health"]: # index 0 corresponds to health 1
			lifeIcon.show()
		else:
			lifeIcon.hide()
		
func _process(_delta):
	if $Control/FPSLabel.visible:
		$Control/FPSLabel.text = "FPS: " + str(Performance.get_monitor(Performance.TIME_FPS)) 
