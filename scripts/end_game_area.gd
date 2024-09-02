extends Area2D

@onready var secret_text_label: Label = $"../CanvasLayer/Control/MarginContainer/ColorRect/VBoxContainer/SecretTextLabel"
@onready var end_text_label: Label = $"../CanvasLayer/Control/MarginContainer/ColorRect/VBoxContainer/EndTextLabel"
@onready var control: Control = $"../CanvasLayer/Control"

@export var secret_message_threshold = 10000

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	print("Game end!")
	GameManager.game_ended()
	
func _ready() -> void:
	GameManager.game_end.connect(show_end_screen)
	
func show_end_screen():
	control.set_deferred("visible", true)
	if GameManager.points >= secret_message_threshold:
		end_text_label.set_deferred("visible", false)
		secret_text_label.set_deferred("visible", true)
	else:
		end_text_label.set_deferred("visible", true)
		secret_text_label.set_deferred("visible", false)
