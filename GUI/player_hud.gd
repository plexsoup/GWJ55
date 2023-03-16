extends CanvasLayer

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent()
	Global.current_hud = self
	_on_hit() # set the health bar.
	%SettingsPanel.hide()
	$ThoughtBubbleTemplate.hide()

func _on_hit():
	for lifeIcon in $Control/HealthBox.get_children():
		if lifeIcon.get_index() < Global.player_stats["health"]: # index 0 corresponds to health 1
			lifeIcon.show()
		else:
			lifeIcon.hide()
		
func _process(_delta):
	if %FPSLabel.visible:
		%FPSLabel.text = "FPS: " + str(Performance.get_monitor(Performance.TIME_FPS)) 


func _on_button_pressed():
	StageManager.reset_level()


func _on_settings_panel_toggle_button_toggled(button_pressed):
	%SettingsPanel.visible = button_pressed
	
func hide_settings():
	%SettingsPanel.visible = false
	%SettingsPanelToggleButton.set_pressed(false)
	
func _on_thought_bubble_requested(text:String, duration:float):
	$ThoughtBubbleTemplate.start(text, duration)
	
