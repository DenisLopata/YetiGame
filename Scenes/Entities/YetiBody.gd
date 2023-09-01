extends CharacterBody2D

var speed : int = 100

func _ready():
	$AnimatedSprite.play()



func follow_player(player_position: Vector2) -> void:
#	position = player_position
#	position.y = player_position.y - 32
#	look_at(player_position)

#	var direction = player_position - position  
#	velocity = direction * speed

#	velocity = (player_position - position).normalized() * speed
	velocity = position.direction_to(player_position) * speed
	var distance = player_position.distance_to(position)
#	print(distance)
	move_and_slide()
