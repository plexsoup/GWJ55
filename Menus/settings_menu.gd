extends Control


var active_bus : int
var active_slider : Slider
var dragging : bool = false
var last_time_polled : int = 0
var polling_interval : int = 100 #msec

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


func _process(_delta):
	if dragging:
		var msec = Time.get_ticks_msec()
		if msec > last_time_polled + polling_interval:
			last_time_polled = msec
			var volumeLinear = active_slider.value
			var volumeDB = linear_to_db(volumeLinear)
			AudioServer.set_bus_volume_db(active_bus, volumeDB)


func _on_master_volume_slider_drag_started():
	active_bus = AudioServer.get_bus_index("Master")
	active_slider = %MasterVolumeSlider
	dragging = true
	#%MusicStream.play()


func _on_master_volume_slider_drag_ended(_value_changed):
	dragging = false
	#%MusicStream.stop()


func _on_sfx_volume_slider_drag_started():
	active_bus = AudioServer.get_bus_index("SFX")
	active_slider = %SFXVolumeSlider
	dragging = true
	%SFXStream.play()
	

func _on_sfx_volume_slider_drag_ended(_value_changed):
	dragging = false
	%SFXStream.stop()



func _on_music_volume_slider_drag_started():
	active_bus = AudioServer.get_bus_index("Music")
	active_slider = %MusicVolumeSlider
	dragging = true
	#%MusicStream.play()



func _on_music_volume_slider_drag_ended(_value_changed):
	%MusicStream.stop()
	


func _on_graphics_button_item_selected(index):
	if index == 0:
		Global.user_settings["graphics"] = "low"
		Global.low_spec = true
	else:
		Global.user_settings["graphics"] = "high"
		Global.low_spec = false

	if StageManager.current_map.has_method("change_graphics_settings"):
		StageManager.current_map.change_graphics_settings()
