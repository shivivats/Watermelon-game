extends MarginContainer

var level_scene = preload("res://scenes/level.tscn").instantiate()
@onready var current_best_label: RichTextLabel = $VBoxContainer/VBoxContainer/CurrentBestLabel


func _ready():
	get_tree().paused = false
	current_best_label.text = "[center][i] Current Best: " + str(GameManager.highscore) + "[/i][/center]"

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level.tscn")



func _on_quit_button_pressed() -> void:
	pass # Replace with function body.
