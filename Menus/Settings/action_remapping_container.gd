extends HBoxContainer

@export var action_name = ""

var listening : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if action_name != "":
		$ActionNameLabel.text = action_name
		if action_name in InputMap.get_actions():
			$ActionKeyButton.text = InputMap.action_get_events(action_name)[0].as_text()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _unhandled_key_input(event):
	if listening:
		InputMap.action_erase_event(action_name, InputMap.action_get_events(action_name)[0] )
		InputMap.action_add_event(action_name, event)
		$ActionKeyButton.text = InputMap.action_get_events(action_name)[0].as_text()
		listening = false


func _on_action_key_button_pressed():
	listening = true
	$ActionKeyButton.text = "Press a key to map " + action_name
