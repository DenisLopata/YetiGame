extends Control

@onready var item_list := $MC/VB/CC/ItemList as ItemList
@onready var bttn_back := $MC/VB/HB/BackButton as TextureButton

@export var save_data: Dictionary

signal bttn_back_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	item_list.size = Vector2(400, 400)
	bttn_back.pressed.connect(on_button_back_pressed.bind(bttn_back))
	if save_data and !save_data.is_empty():
		var list_item_cnt = 1
		for i in save_data.keys():
			var txt := str(list_item_cnt) + ". " +  str(save_data[i]["hightscore"])
			item_list.add_item(txt)
			list_item_cnt += 1
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func on_button_back_pressed(button : TextureButton):
	bttn_back_pressed.emit()
	pass
