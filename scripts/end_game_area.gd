extends Area2D

@onready var secret_text_label: Label = $"../CanvasLayer/Control/MarginContainer/ColorRect/VBoxContainer/SecretTextLabel"
@onready var end_text_label: Label = $"../CanvasLayer/Control/MarginContainer/ColorRect/VBoxContainer/EndTextLabel"
@onready var control: Control = $"../CanvasLayer/Control"
@onready var end_game_show_message_timer: Timer = $EndGameShowMessageTimer

@export var secret_message_threshold = 10000

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	print("Game end!")
	GameManager.game_ended()
	
func _ready() -> void:
	GameManager.game_end.connect(start_end_game_timer)
	
func start_end_game_timer():
	print("Starting timer!")
	Engine.set_time_scale(0.1)
	end_game_show_message_timer.start()

func show_end_screen():
	control.set_deferred("visible", true)
	if GameManager.points >= secret_message_threshold:
		end_text_label.set_deferred("visible", false)
		secret_text_label.set_deferred("visible", true)
	else:
		end_text_label.set_deferred("visible", true)
		secret_text_label.set_deferred("visible", false)


func _on_end_game_show_message_timer_timeout() -> void:
	get_tree().paused = true
	show_end_screen()

func _on_back_to_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/start-screen.tscn")
