extends CharacterBody2D

@export var speed_max := 675.0
@export var acceleration := 1500.0
@export var angular_speed_max := deg_to_rad(150)
@export var angular_acceleration := deg_to_rad(1200)
@export var drag_factor := 0.05
@export var angular_drag_factor := 0.1

@onready var angular_velocity : float = 0.0
@onready var trail_full := preload("res://Assets/Trails/trail_full.png")
@onready var trail_end := preload("res://Assets/Trails/trail_end.png")

@export var player_speed : int = 0
@export var acceleration_simple := 1
@export var friction_simple: float = 5
const SPEED: float = 300.0
const JUMP_VELOCITY: float = -400.0
var count: int = 0
var can_move := false as bool
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
# A factor that controls the character's inertia.
@export var friction: float = 0.18
@onready var trail_node := $Trail as Marker2D
@onready var trail_sprite := $Trail/TrailSprite as Sprite2D

#region movement
func _physics_process(delta: float) -> void:
	if can_move:
		move(delta)

func move(delta: float) -> void:
#	move_spaceship(delta)
	var speed = move_simple(delta)
	player_speed = speed
#	add_trail(speed)

func accelerate(direction: Vector2) -> void:
	velocity = velocity.move_toward(SPEED * direction, acceleration_simple)
	
func apply_friction() -> void:
	velocity = velocity.move_toward(Vector2.ZERO, friction_simple)

	
func add_trail(speed: int) -> void:
	
	
	#remove old children
	var trail_children = trail_node.get_child_count()
	if(trail_children > 0):
		for child in trail_node.get_children():
			child.queue_free()
	trail_sprite = Sprite2D.new()
	trail_node.add_child(trail_sprite)
		
	#add new trail
	if speed == 0:
		trail_sprite.visible = false
	elif speed <= 100:
		trail_sprite.visible = true
		trail_sprite.position = Vector2(0, - 16)
		trail_sprite.texture = trail_end
	elif speed > 100 && speed <= 200:
		trail_sprite.visible = true
		trail_sprite.position = Vector2(0, - 16)
		trail_sprite.texture = trail_full
		var trail_sprite2 = trail_sprite.duplicate()
		trail_sprite2.position = Vector2(0, - 32)
		trail_sprite2.texture = trail_end
		$Trail.add_child(trail_sprite2)
	elif speed > 200:
		trail_sprite.visible = true
		trail_sprite.position = Vector2(0, - 16)
		trail_sprite.texture = trail_full
		var trail_sprite2 = trail_sprite.duplicate()
		trail_sprite2.position = Vector2(0, - 32)
		trail_sprite2.texture = trail_full
		$Trail.add_child(trail_sprite2)
		var trail_sprite3 = trail_sprite.duplicate()
		trail_sprite3.position = Vector2(0, - 48)
		trail_sprite3.texture = trail_end
		$Trail.add_child(trail_sprite3)
			
		
		
#	trail_sprite.position = Vector2(0, - 16)
#	trail_sprite.texture = trail_full
#	var trail_sprite2 = trail_sprite.duplicate()
#	trail_sprite2.position = Vector2(0, - 32)
#	trail_sprite2.texture = trail_end
#	add_child(trail_sprite2)

func move_simple(delta: float) -> int:
	var direction := Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	
	if direction.length() > 1.0:
		direction = direction.normalized()
		
	if direction != Vector2.ZERO:
		accelerate(direction)
	else:
		apply_friction()
		
	# Using the follow steering behavior.
#	var target_velocity = direction * SPEED
#	var old_velocity = (target_velocity - velocity) * friction
#	velocity += (target_velocity - velocity) * friction
#	var speed := int(velocity.distance_to(old_velocity))
	
	var speed := velocity.y
	move_and_slide()
	return speed
	
func move_spaceship(delta: float) -> void:
	velocity = velocity.limit_length(speed_max)

	angular_velocity = clamp(angular_velocity, -angular_speed_max, angular_speed_max)
	angular_velocity = lerp(angular_velocity, 0.0, angular_drag_factor)

	move_and_slide()
	rotation += angular_velocity * delta

	var movement := _get_movement()

	if is_equal_approx(movement.y, 0):
		velocity = (velocity.lerp(Vector2.ZERO, drag_factor))

	var direction := Vector2.UP.rotated(rotation)

	velocity += movement.y * direction * acceleration * delta
	angular_velocity += movement.x * angular_acceleration * delta
	
func _get_movement() -> Vector2:
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
#endregion

func _on_level_ready_countdown_done() -> void:
	can_move = true
