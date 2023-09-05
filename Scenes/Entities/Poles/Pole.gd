extends StaticBody2D

@export var set_flip_h = false : set = _set_flip

func _set_flip(val : bool):
	$Sprite.set_flip_h(val)
