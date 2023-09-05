class_name Map1
extends WorldGenerator

var background_tiles: Array[Vector2i] = [Vector2i(0,0)
, Vector2i(1,1)
, Vector2i(5,0)
, Vector2i(4,1)
, Vector2i(1,4)
, Vector2i(4,4)]

var map_size_y := 100

@onready var _screen_size = self.get_viewport_rect().size
@onready var player = $Player/PlayerBody as CharacterBody2D
#@onready var yeti_node = $Yeti as Node2D
@onready var ground = $Ground as TileMap
@onready var path = $Path as TileMap

func _ready() -> void:
	Flag = load("res://Scenes/Entities/Flag.tscn")
	Pole = load("res://Scenes/Entities/Poles/Pole.tscn")
	generate_tiles_around_player()
	var player_position = player.position as Vector2
	_generate_map(player_position)
#	_generate_sector(0,0)
#	generate()
#	yeti_node = Node2D.new()
	add_yeti()

func add_yeti() -> void:
	var yeti = yeti_node.instantiate()
	yeti.position = player.position
	yeti.position.y = yeti.position.y - 64
	add_child(yeti)
	Yeti = yeti
	
	
func _physics_process(_delta: float) -> void:
	$Yeti/YetiBody.follow_player(player.position)
	
func generate_tiles_around_player() -> void:
	
		var glbl = player.global_position
		var tile_pos = ground.local_to_map(glbl)
		
		var path_coords := []
		var background_coords := []
		var path_width := 5
		var cnt = 0
		for x in range(- 100, 100):
			for y in range( - 100, map_size_y):
				var cell_rect := Vector2(
						tile_pos.x + x,
						tile_pos.y + y
					)
				background_coords.append(cell_rect)
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
		
		#get all coords that are not path
		non_path_array = background_coords
		for coord in path_coords:
			var non_path = non_path_array.has(coord)
			var same_index = non_path_array.bsearch(coord)
			if non_path:
				non_path_array.remove_at(same_index)
				
		non_path_array_global = get_global_coords_from_local(non_path_array, ground)
		#convert them to global coords
#		for non in non_path_array:
#			var tile_pos2 = ground.map_to_local(non)
#			non_path_array_global.append(tile_pos2)
			
		#convert path to global
		path_array_global = get_global_coords_from_local(path_coords, path)
		path_pole_array_global = path_array_global as Array
		path_pole_array_global = path_pole_array_global.filter(infront_player_position)
#		for path_coord in path_coords:
#			var tile_pos2 = path.map_to_local(path_coord)
#			path_array_global.append(tile_pos2)
			
				
func infront_player_position(vector: Vector2):
	if vector.y > player.position.y:
		return vector
	
func get_global_coords_from_local(array: PackedVector2Array, tileMap: TileMap) -> PackedVector2Array:
	var helper_array = PackedVector2Array()
	#convert path to global
	for array_coord in array:
		var tile_pos = tileMap.map_to_local(array_coord)
		helper_array.append(tile_pos)
	return helper_array
	

