class_name WorldGenerator
extends SaveGame

## The number of items to place on map.
@export var item_density := 300
@export var number_of_poles := 10

## The Flags
@export var Flag: PackedScene
@export var Pole: PackedScene

## Trees
@export var TreeGreenBig: PackedScene
@export var TreeBrownBig: PackedScene
@export var TreeGreenSmall: PackedScene
@export var TreeBrownSmall: PackedScene

## Enemies
@export var Yeti: Node2D

@onready var _screen_size = self.get_viewport_rect().size
@onready var yeti_node := preload("res://Scenes/Entities/Yeti.tscn")
var non_path_array = PackedVector2Array()
var non_path_array_global = PackedVector2Array()
var path_array_global = PackedVector2Array()
var path_pole_array_global = []
var current_pole_position : Vector2
var img_size_px := 16
var pole_position_dict = {}
var player_id : int
var last_path_coord_y: int
var player_current_position: Vector2i

signal signal_on_player_pole_axis(poles_y: Array)
signal signal_player_reached_finish_line()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta: float):
	#check if empty dictionary
	if pole_position_dict:
		_add_ray_to_poles(pole_position_dict)
	#check if player reached finish
	if player_current_position:
		if player_current_position.y >= last_path_coord_y:
			signal_player_reached_finish_line.emit()
	pass
	
func _generate_map(player_position: Vector2) -> void:
	_add_trees()
	_add_flags()
	pole_position_dict = _add_poles() as Dictionary
	
	# We store references to all asteroids to free them later.
#	_sectors[Vector2(x_id, y_id)] = sector_data

func _add_ray_to_poles(pole_position_dict: Dictionary) -> void:
	
	var space_state = get_world_2d().direct_space_state
	
	for value in pole_position_dict.values():
		var start_coord = value["start"] as Vector2
		var end_coord = value["end"] as Vector2
		
		# use global coordinates, not local to node for ray
		var ray_start := Vector2(0 - _screen_size.x, start_coord.y)
		var ray_end = Vector2(0 + _screen_size.x, start_coord.y)
		
		#TODO use bits to split layers
		var mask_layer = 4 #this is the layer 3
		var query = PhysicsRayQueryParameters2D.create(ray_start, ray_end, mask_layer, [self])
		
		var result = space_state.intersect_ray(query)
		if result:
			if result.collider_id == player_id:
				var key = pole_position_dict.find_key(value)
				#remove from dictionary once player hit so we do not generate any more rays for pole
				#TODO see if removing in for loop good idea
				pole_position_dict.erase(key)
				signal_on_player_pole_axis.emit(value)
		
		pass

func _add_trees() -> void:
	# List of entities generated in this sector.
	var tree_types = [ TreeGreenBig, TreeBrownBig, TreeGreenSmall, TreeBrownSmall ]
	var sector_data := []
	for _i in range(item_density):
		var tree_rand = tree_types[randi()%tree_types.size()] as PackedScene
		var tree := tree_rand.instantiate()
		add_child(tree)
	
		#TODO remove values from array so we do not spawn on same tile
		tree.position = non_path_array_global[randi()%non_path_array_global.size()]
		sector_data.append(tree)
	
func _add_flags() -> void:
	# List of entities generated in this sector.
	var sector_data := []
	for _i in range(item_density / 5):
		var flag := Flag.instantiate()
		add_child(flag)
	
		#TODO remove values from array so we do not spawn on same tile
		flag.position = non_path_array_global[randi()%non_path_array_global.size()]
		sector_data.append(flag)
	
func _add_poles() -> Dictionary:
	# List of entities generated in this sector.
	var sector_data := []
	var pole_dictionary = {}
	for _i in range(number_of_poles):
		if path_pole_array_global.size() == 0:
			return pole_dictionary
		#create first pole
		var pole := Pole.instantiate()
		add_child(pole)
		#get random position
		var pole_index = randi()%path_pole_array_global.size()
		var pole_position = path_pole_array_global[pole_index]
		current_pole_position = pole_position
		
		#remove that position so we do not spawn two poles on same tile
		path_pole_array_global.remove_at(pole_index)
		#get all poles on same Y axis
		var pole_same_y = path_pole_array_global.filter(same_y_position)
		#remove all on same Y axis for future generation
		path_pole_array_global = path_pole_array_global.filter(not_same_y_position)
		
		
		#create second pole
		var pole_end := Pole.instantiate()
		add_child(pole_end)
		#space between two poles on X Axis
		pole_same_y = pole_same_y.filter(space_between_x)
		
		pole_end.position = pole_same_y[randi()%pole_same_y.size()]
#		pole_end.rotation = deg_to_rad(180)
		
		
		pole.position = pole_position
		
		#create space on Y axis
		path_pole_array_global = path_pole_array_global.filter(space_between_y)
		var start_pos = Vector2.ZERO
		var end_pos = Vector2.ZERO
		if(pole.position.x > pole_end.position.x):
			pole.set_flip_h = true
			start_pos = pole_end.position
			end_pos = pole.position
		else:
			pole_end.set_flip_h = true
			start_pos = pole.position
			end_pos = pole_end.position
			
		sector_data.append(pole)
		sector_data.append(pole_end)
		pole_dictionary["Pole" + str(_i)] = {"start" : start_pos, "end" : end_pos }
	return pole_dictionary
	
func space_between_y(vector: Vector2):
	if vector.y <= current_pole_position.y - img_size_px * 5 or vector.y >= current_pole_position.y + img_size_px * 5:
		return vector
		

func space_between_x(vector: Vector2):
	if vector.x <= current_pole_position.x - img_size_px * 3 or vector.x >= current_pole_position.x + img_size_px * 3:
		return vector
		

func same_y_position(vector: Vector2):
	if vector.y == current_pole_position.y:
		return vector
		

func not_same_y_position(vector: Vector2):
	if vector.y != current_pole_position.y:
		return vector
		
