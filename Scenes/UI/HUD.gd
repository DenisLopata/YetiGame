extends CanvasLayer

@export var screen_size : Vector2 = Vector2.ZERO : set = _set_label_positions
@export var level_time : float = 0.00 : set = _set_level_time

@onready var level_time_node := $LevelTime as Label
@onready var level_timer_node := $LevelTimer as Timer
@onready var center_message_node := $CenterMessage as Label
@onready var center_message_timer_node := $CenterMessageTimer as Timer

@export var total_time : float

var level_start_time = 3 as int

signal signal_on_level_ready_countdown_done

#setters
func _set_level_time(time: float) -> void:
	level_time_node.text = str(time)
	level_time = time

func _set_label_positions(val : Vector2) -> void:
	level_time_node.position.x = (val.x /2) - 16
	level_time_node.position.y = 20
	level_time_node.text = str(level_time)
	
	
	center_message_node.label_settings = LabelSettings.new()
	center_message_node.label_settings.font_size = 64
	center_message_node.position.x = (val.x /2) - 16
	center_message_node.position.y = (val.y /2)
	center_message_node.text = str(level_start_time)
	
func _ready():
	center_message_timer_node.wait_time = 1.0
	level_timer_node.wait_time = 0.1
	total_time = 0.00

func start_center_message_timer() -> void:
	center_message_timer_node.start()
	center_message_timer_node.timeout.connect(self._on_signal_center_message_timer_timeout)
	
func start_level_timer() -> void:
	level_timer_node.start()
	level_timer_node.timeout.connect(self._on_signal_level_timer_timeout)

func stop_level_timer() -> void:
	level_timer_node.stop()

func increment_level_timer_by(time: float) -> void:
	total_time = total_time + time
	level_time_node.modulate = Color(Color.DARK_RED)
	await get_tree().create_timer(1.0).timeout
	level_time_node.modulate = Color(Color.WHITE)

#signals
#increment level time by timer wait time 0.1sec
func _on_signal_level_timer_timeout() -> void:
	var current_time := total_time as float
	var timer_wait_time := level_timer_node.wait_time as float
	var add = current_time + timer_wait_time as float
	level_time = snappedf(add, 0.01) as float
	total_time = level_time

func _on_signal_center_message_timer_timeout() -> void:
	level_start_time -= 1
	center_message_node.text = str(level_start_time)
	if level_start_time == 0:
		center_message_timer_node.stop()
		signal_on_level_ready_countdown_done.emit()
		center_message_node.visible = false
		start_level_timer()
