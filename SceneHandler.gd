extends Node2D

@onready var main_menu_node := $MainMenu
@onready var bttn_new_game := $MainMenu/MC/HB/VB/NewGame
@onready var bttn_high_scores := $MainMenu/MC/HB/VB/HighScores
@onready var bttn_quit := $MainMenu/MC/HB/VB/Quit
@onready var map1_node := preload("res://Scenes/MainScenes/Map1.tscn")

func _ready():
	load_main_menu()

func load_main_menu():
	bttn_new_game.connect("pressed", self.on_new_game_pressed)
	bttn_high_scores.connect("pressed", self.on_highscores_pressed)
	bttn_quit.connect("pressed", self.on_quit_pressed)

func on_new_game_pressed():
	main_menu_node.queue_free()
	get_tree().change_scene_to_packed(map1_node)
	
func on_highscores_pressed():
	get_tree().quit()
	
func on_quit_pressed():
	get_tree().quit()
