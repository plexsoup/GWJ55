extends PanelContainer

var thought_text : String

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_timer_timeout():
	queue_free()



func activate(newText, duration):
	$Label.text = newText
	thought_text = newText
	show()
	$Timer.set_wait_time(duration)
	$Timer.start()


func start(text, duration):
	var newThoughtBubble = self.duplicate(DUPLICATE_USE_INSTANTIATION)
	get_parent().add_child(newThoughtBubble)

	newThoughtBubble.activate(text, duration)
	
