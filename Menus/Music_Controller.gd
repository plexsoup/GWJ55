extends AudioStreamPlayer
@onready var Mplayer = AudioStreamPlayer.new()
var fade = false 
func _ready() -> void:
	add_child(Mplayer)
	stream = load("res://Music/MUS_TitleV2_9M_7-4_78.mp3")
	autoplay = true
	play()

func play_song(Song) ->void:
	fade = true
	Mplayer.stream = load("res://Music/" +Song+ ".mp3")
	Mplayer.volume_db = -60
	bus = "Music"
	Mplayer.autoplay = true
	play()
	
	
	
func _process(delta: float) -> void:
	if fade:
		volume_db -= 40*delta
		Mplayer.volume_db += 40*delta
			
		if Mplayer.volume_db> 0:
			volume_db = 0 
			Mplayer.volume_db = -60
			
			stream = Mplayer.stream
			play(Mplayer.get_playback_position())
			
			Mplayer.stop()
			fade = false



	

