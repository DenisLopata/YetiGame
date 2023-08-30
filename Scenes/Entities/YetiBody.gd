extends CharacterBody2D

var speed : int = 2

func _ready():
	$AnimatedSprite.play()



func follow_player(player_position: Vector2) -> void:
#	position = player_position
#	position.y = player_position.y - 32
#	look_at(player_position)
	var direction = player_position - position  
	velocity = direction
	move_and_slide()
