extends Node2D

@onready var main_menu_node := $MainMenu as Control
@onready var bttn_new_game := $MainMenu/MC/HB/VB/NewGame
@onready var bttn_high_scores := $MainMenu/MC/HB/VB/HighScores
@onready var bttn_quit := $MainMenu/MC/HB/VB/Quit
@onready var _screen_size = self.get_viewport_rect().size
#@onready var map1_node := preload("res://Scenes/MainScenes/Map1.tscn")

var game_scene
var scores_scene

func _ready():
	load_main_menu()

func load_main_menu():
	if !main_menu_node:
		main_menu_node = preload("res://Scenes/UI/MainMenu.tscn").instantiate()
		main_menu_node.size = _screen_size
		add_child(main_menu_node)
		bttn_new_game = $MainMenu/MC/HB/VB/NewGame
		bttn_high_scores = $MainMenu/MC/HB/VB/HighScores
		bttn_quit = $MainMenu/MC/HB/VB/Quit
	bttn_new_game.connect("pressed", self.on_new_game_pressed)
	bttn_high_scores.connect("pressed", self.on_highscores_pressed)
	bttn_quit.connect("pressed", self.on_quit_pressed)

func on_new_game_pressed():
	main_menu_node.queue_free()
	game_scene = preload("res://Scenes/MainScenes/Map1.tscn").instantiate()
	game_scene.connect("game_finished", self.on_game_finished)
	add_child(game_scene)
	
func on_game_finished():
	game_scene.queue_free()
	load_main_menu()

	
func on_highscores_pressed():
	main_menu_node.queue_free()
	scores_scene = preload("res://Scenes/UI/Scores/Scores.tscn").instantiate()
	scores_scene.size = _screen_size
	add_child(scores_scene)
	
func on_quit_pressed():
	get_tree().quit()
