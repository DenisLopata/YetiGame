extends Area2D

@export var set_flip_h = false : set = _set_flip

func _set_flip(val : bool):
	$Sprite.set_flip_h(val)
	pass

## put it on another collision layer so we do not crash into it
func _ready():
#	collision_layer = 2
	pass


func _on_area_entered(area):
	pass # Replace with function body.
	print("ENTERED")
