class_name Map1
extends WorldGenerator

var background_tiles: Array[Vector2i] = [Vector2i(0,0)
, Vector2i(1,1)
, Vector2i(5,0)
, Vector2i(4,1)
, Vector2i(1,4)
, Vector2i(4,4)]


## 20 is minimum too fill screen 640px width / 16px tile size
## that is 40, but we split on left and right
var map_size_x := 40
var map_size_y := 200

var pole_miss_time = 1.00 as float
@onready var player_node = $Player as Node2D
@onready var player = $Player/PlayerBody as CharacterBody2D
@onready var ground = $Ground as TileMap
@onready var path = $Path as TileMap
@onready var hud_node = $HUD as CanvasLayer

func _ready() -> void:
	Flag = load("res://Scenes/Entities/Flag.tscn")
	Pole = load("res://Scenes/Entities/Poles/Pole.tscn")
	TreeGreenBig = load("res://Scenes/Entities/Trees/TreeGreenBig.tscn")
	TreeBrownBig = load("res://Scenes/Entities/Trees/TreeBrownBig.tscn")
	TreeGreenSmall = load("res://Scenes/Entities/Trees/TreeGreenSmall.tscn")
	TreeBrownSmall = load("res://Scenes/Entities/Trees/TreeBrownSmall.tscn")
	hud_node.screen_size = _screen_size
	generate_tiles_around_player()
	var player_position = player.position as Vector2
	_generate_map(player_position)
	self.connect("signal_on_player_pole_axis", self._on_player_pole_axis)
	add_yeti()
	hud_node.start_level_timer()
#	player_node.z_index = 1

#signal when player reaches pole Y axis
#check if player inside poles or outside
#emited once per pole pair
func _on_player_pole_axis(poles_y: Dictionary) -> void:
	var player_pos = player.position as Vector2
	var start_pole_pos = poles_y["start"]
	var end_pole_pos = poles_y["end"]
	if player_pos.x >= start_pole_pos.x and player_pos.x <= end_pole_pos.x:
		print("Inside")
	else:
		print("Outside")
		hud_node.increment_level_timer_by(pole_miss_time)
	pass

#put Yeti on map
func add_yeti() -> void:
	var yeti = yeti_node.instantiate()
	yeti.position = player.position
	yeti.position.y = yeti.position.y - 64
	add_child(yeti)
	Yeti = yeti
	
#for testing, not used in game
func _draw():
#	draw_line(Vector2(0 - _screen_size.x, 50), Vector2(0 + _screen_size.x, 50), Color(Color.AQUA), 1)
#	draw_line(Vector2(50, 50), Vector2(55, 55), Color(255, 0, 0), 1)
	pass
	
func _physics_process(_delta: float) -> void:
	$Yeti/YetiBody.follow_player(player.position)
	
	var col_val = player.collision_layer
	var col_mask = player.collision_mask
	player_id = player.get_instance_id()
	
	#delegate to original class
	super._physics_process(_delta)
	
func generate_tiles_around_player() -> void:
	
		var glbl = player.global_position
		var tile_pos = ground.local_to_map(glbl)
		
		var path_coords := []
		var background_coords := []
		var path_width := 5
		var cnt = 0
		for x in range(- map_size_x, map_size_x):
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
			
		#convert path to global
		path_array_global = get_global_coords_from_local(path_coords, path)
		path_pole_array_global = path_array_global as Array
		path_pole_array_global = path_pole_array_global.filter(infront_player_position)
			
				
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
	



