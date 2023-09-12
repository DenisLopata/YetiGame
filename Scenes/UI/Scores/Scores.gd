extends Control

@onready var rich_text_label := $MC/CenterContainer/RichTextLabel as RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	rich_text_label.add_text("brrr")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
