extends TextureButton
var Vis = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $".".is_hovered():
		$AnimatedSprite2D.play("Hover")
		$AnimatedSprite2D.visible 
	else:
		$AnimatedSprite2D.play("Defult")
		
