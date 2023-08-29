class_name Map1
extends WorldGenerator

var background_tiles: Array[Vector2i] = [Vector2i(0,0)
, Vector2i(1,1)
, Vector2i(5,0)
, Vector2i(4,1)
, Vector2i(1,4)
, Vector2i(4,4)]

## The Flags
@export var Flag: PackedScene

@onready var _screen_size = get_viewport_rect().size
## The number of asteroids to place in each sector.
@export var asteroid_density := 3
@onready var player = $Player/PlayerBody
@onready var ground = $Ground as TileMap
@onready var path = $Path as TileMap

func _ready() -> void:
	Flag = load("res://Scenes/Entities/Flag.tscn")
	generate()
	generate_tiles_around_player()

func _physics_process(_delta: float) -> void:
	# Every frame, we compare the player's position to the current sector. If
	# they move far enough from it, we need to update the world.
	var sector_location := _current_sector * sector_size
	var distance = player.global_position.distance_squared_to(sector_location)
	
	if player.global_position.distance_squared_to(sector_location) > _sector_size_squared:
		# Our function to update the sectors takes a vector to offset. As the
		# player can be moving left, right, up, or down, we store that
		# information in our sector_offset variable.
		var sector_offset := Vector2.ZERO
		sector_offset = (player.global_position - sector_location) / sector_size
		sector_offset.x = int(sector_offset.x)
		sector_offset.y = int(sector_offset.y)
		_update_sectors(sector_offset)
		generate_tiles_around_player()
		print("--------DONE GENERATE------------")
	
func generate_tiles_around_player() -> void:
	
		var glbl = player.global_position
		var tile_pos = ground.local_to_map(glbl)
		
		var path_coords := []
		var path_width := 5
		var cnt = 0
		for x in range(- 100, 100):
			for y in range( - 100, 100):
				var cell_rect := Vector2(
						tile_pos.x + x,
						tile_pos.y + y
					)
#				ground.set_cell(0, cell_rect, 1, Vector2(1,1))
				var rng_bckg_tile = background_tiles[randi()%background_tiles.size()]
				ground.set_cell(0, cell_rect, 1, rng_bckg_tile)
				if x >= -path_width and x <= path_width:
					path_coords.append(Vector2(x, cell_rect.y))
					if cnt > 100 and cnt < 150:
						path_coords.append(Vector2(path_width + 1, cell_rect.y))
					if cnt > 103 and cnt < 148:
						path_coords.append(Vector2(path_width + 2, cell_rect.y))
					
					cnt = cnt + 1
		path.set_cells_terrain_connect(0, path_coords, 0, 0)
				

	
func generate_collision_path_around_player(x: int, cell_rect: Vector2) -> void:
		var path_coords := []
		var path_width := 5
		if x >= -path_width and x <= path_width:
			if x == -path_width:
					path.set_cell(0, Vector2(x, cell_rect.y), 0, Vector2i(1,0))
			elif x == path_width:
					path.set_cell(0, Vector2(x, cell_rect.y), 0, Vector2i(4,0))
			else:
					path.set_cell(0, Vector2(x, cell_rect.y), 0, Vector2i(2,0))
	
# Generates items and places them inside
# of the sector's bounds with a random position, rotation, and scale.
func _generate_sector(x_id: int, y_id: int) -> void:
	pass
#	_rng.seed = make_seed_for(x_id, y_id)
	
	# List of entities generated in this sector.
	var sector_data := []
#	var position = _generate_random_position(x_id, y_id)
	for _i in range(asteroid_density):
		var flag := Flag.instantiate()
		add_child(flag)
	
		# We generate a random position for each asteroid within the rectangle's bounds.
		flag.position = _generate_random_position(x_id, y_id)
#		flag.rotation = _rng.randf_range(-PI, PI)
#		flag.scale *= _rng.randf_range(0.2, 1.0)
		sector_data.append(flag)

	# We store references to all asteroids to free them later.
	_sectors[Vector2(x_id, y_id)] = sector_data

# Returns a random position within the sector's bounds, given the sector's coordinates.
func _generate_random_position(x_id: int, y_id: int) -> Vector2:
	# Calculate the sector boundaries based checked the current x and y sector
	# coordinates.
	var sector_position = Vector2(x_id * sector_size, y_id * sector_size)
	var sector_top_left = Vector2(
		sector_position.x - _half_sector_size, sector_position.y - _half_sector_size
	)
	var sector_bottom_right = Vector2(
		sector_position.x + _half_sector_size, sector_position.y + _half_sector_size
	)
	return Vector2(
		_rng.randf_range(sector_top_left.x, sector_bottom_right.x),
		_rng.randf_range(sector_top_left.y, sector_bottom_right.y)
	)
	
