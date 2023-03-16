@tool

extends Area3D

@export var hint_text : String = "I'm doing great!" : set = set_hint_text, get = get_hint_text
@export var times_to_display : int = 1
@export var duration : float = 3.0 # seconds
@export var local_coords : bool = false # text follows player or stays in scene?

var times_previously_displayed : int = 0

signal player_entered_zone

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if Engine.is_editor_hint():
		pass
	else:
		$Label3D.text = hint_text
		$Label3D.hide()
		$Timer.set_wait_time(duration)
		$TitleInEditor.hide()


func set_hint_text(newText):
	hint_text = newText
	$Label3D.text = newText

func get_hint_text():
	return hint_text

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if "player" in body.name.to_lower():
		if times_previously_displayed < times_to_display:
			if !local_coords and Global.current_hud != null:
				if not player_entered_zone.is_connected(Global.current_hud._on_thought_bubble_requested):
					player_entered_zone.connect(Global.current_hud._on_thought_bubble_requested)
				player_entered_zone.emit(hint_text, duration)
			else:
				$Label3D.show()
				$Timer.start()
			times_previously_displayed += 1
			



func _on_timer_timeout():
	$Label3D.hide()
