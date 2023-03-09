@tool
extends PanelContainer

@export var postit_title : String : set = set_postit_title, get = get_postit_title

@export_multiline var postit_description : String: set = set_postit_description, get = get_postit_description

@export var note_color : Color : set = set_note_color, get = get_note_color
#@export_range(0.0, 1.0) var transparency : float = 0.5 : set = set_note_transparency


# Called when the node enters the scene tree for the first time.
func _ready():
	if Engine.is_editor_hint():
		pass

func set_note_color(newColor):
	$ColorRect.color = newColor
	note_color = newColor

func get_note_color():
	return note_color
	
	
#func set_note_transparency(newValue):
#	pass
	

func set_postit_title(newText : String) -> void:
	postit_title = newText
	%TitleLabel.text = postit_title

func get_postit_title() -> String:
	return postit_title

func set_postit_description(newText : String) -> void:
	postit_description = newText
	%DescriptionLabel.text = postit_description

func get_postit_description() -> String:
	return postit_description

## Description: find hash tags in Description text and modify color of note
func locate_tags():
	var first_hashtag_index = %DescriptionLabel.text.find("#")
	

