extends Node2D

@onready var trail_node := $GlobalTrail as Marker2D
@onready var trail_sprite := $GlobalTrail/Sprite as Sprite2D
@onready var player_body_node := $PlayerBody as CharacterBody2D
@onready var trail_full := preload("res://Assets/Trails/trail_full.png")
@onready var trail_end := preload("res://Assets/Trails/trail_end.png")

func _physics_process(delta):
	
	var player_body_position := player_body_node.position
	var player_body_velocity := player_body_node.velocity
	var player_body_speed : int = player_body_node.player_speed
	
	#remove old children
	var trail_children_count := trail_node.get_child_count()
	if(trail_children_count > 0):
		for i in range(trail_children_count):
			if i > 100:
				var child = trail_node.get_child(0)
				child.queue_free()
				
	if player_body_speed > 0:
		if(trail_children_count > 0):
			var last_child := trail_node.get_child(trail_children_count - 1) as Sprite2D
			var distance = last_child.position.distance_to(player_body_position)
#			print(distance - 16)
			if distance > 21:
				trail_sprite = Sprite2D.new()
				trail_sprite.position = Vector2(player_body_position.x, player_body_position.y - 16)
				trail_sprite.texture = trail_full
				trail_node.add_child(trail_sprite)
	pass
