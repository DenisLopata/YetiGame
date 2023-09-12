extends Node2D

@onready var main_menu_node := $MainMenu
@onready var bttn_new_game := $MainMenu/MC/HB/VB/NewGame
@onready var bttn_high_scores := $MainMenu/MC/HB/VB/HighScores
@onready var bttn_quit := $MainMenu/MC/HB/VB/Quit
#@onready var map1_node := preload("res://Scenes/MainScenes/Map1.tscn")

var game_scene

func _ready():
	load_main_menu()

func load_main_menu():
	main_menu_node = preload("res://Scenes/MainScenes/Map1.tscn").instantiate()
	bttn_new_game.connect("pressed", self.on_new_game_pressed)
	bttn_high_scores.connect("pressed", self.on_highscores_pressed)
	bttn_quit.connect("pressed", self.on_quit_pressed)
	add_child(game_scene)

func on_new_game_pressed():
	main_menu_node.queue_free()
	game_scene = preload("res://Scenes/MainScenes/Map1.tscn").instantiate()
	game_scene.connect("game_finished", self.on_game_finished)
	add_child(game_scene)
#	get_tree().change_scene_to_packed(map1_node)
	
func on_game_finished():
	game_scene.queue_free()
	load_main_menu()
#	var main_menu = load("res://Scenes/UI/MainMenu.tscn").instantiate()
#	add_child(main_menu)
#	get_tree().change_scene_to_packed(preload("res://Scenes/UI/MainMenu.tscn"))

	
func on_highscores_pressed():
	get_tree().quit()
	
func on_quit_pressed():
	get_tree().quit()
