class_name SaveGame
extends MyNode2D

var score_file = "user://highscore.save"
@export var highscore : float

#enum DATA_REQUESTS { SAVE, LOAD }

var save_dict = {
	"player_id": "",
	"hightscore": "",
	"map_id": "",
	"attempt": ""
}

#signal on_load_game_requested(data: Dictionary)

func _ready() -> void:
#	self.ready.connect(request_saved_data.bind(DATA_REQUESTS))
	pass

#func request_saved_data(request_type: DATA_REQUESTS) -> void:
#
#	if request_type == DATA_REQUESTS.LOAD:
#		var load_data = load_scores_data()
#		on_load_game_requested.emit(load_data)
#	pass

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
	
func load_scores_data() -> Dictionary :
	if not FileAccess.file_exists(score_file):
		return {} # Error! We don't have a save to load.
		
	var save_game = FileAccess.open(score_file, FileAccess.READ)
	var save_data = {}
	var cnt = 0
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
			save_data["Run" + str(cnt)] = {}
			save_data["Run" + str(cnt)]["player_id"] = node_data["player_id"]
			save_data["Run" + str(cnt)]["hightscore"] = node_data["hightscore"]
			save_data["Run" + str(cnt)]["map_id"] = node_data["map_id"]
			cnt += 1
	
	pass
	return save_data

