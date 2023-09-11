class_name SaveGame
extends MyNode2D

var score_file = "user://highscore.save"
@export var highscore : float

var save_dict = {
	"player_id": "",
	"hightscore": "",
	"map_id": "",
	"attempt": ""
}

func _ready() -> void:
	pass

func save_score() -> void:
	
	var file : FileAccess
	if not FileAccess.file_exists(score_file):
		file = FileAccess.open(score_file, FileAccess.WRITE)
	else:
		file = FileAccess.open(score_file, FileAccess.READ_WRITE)
		
	file.seek_end()
#	var file = FileAccess.open(score_file, FileAccess.WRITE)
	save_dict["player_id"] = 1
	save_dict["hightscore"] = highscore
	save_dict["map_id"] = 1
	
	# JSON provides a static method to serialized JSON string.
	var json_string = JSON.stringify(save_dict)
	file.store_line(json_string)
#	file.store_string(str(highscore))
	
func load_score() :
	if not FileAccess.file_exists(score_file):
		return # Error! We don't have a save to load.
		
	var save_game = FileAccess.open(score_file, FileAccess.READ)
#	var content = file.get_float()
#	return content
	while save_game.get_position() < save_game.get_length():
			var json_string = save_game.get_line()
			
			# Creates the helper class to interact with JSON
			var json = JSON.new()
			
			# Check if there is any error while parsing the JSON string, skip in case of failure
			var parse_result = json.parse(json_string)
			if not parse_result == OK:
				print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
				continue
				
			# Get the data from the JSON object
			var node_data = json.get_data()
			pass

