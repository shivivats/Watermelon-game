extends Node2D

@onready var game_manager = %GameManager

@onready var rigid_body = $RigidBody2D


func _ready():
	game_manager = get_tree().current_scene.get_node("%GameManager")
	rigid_body.connect("body_shape_entered", _on_body_shape_entered)

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	#print("body collided with shape!")
	#print("body: " + str(body.get_groups()))
	#print("self: " + str(self.get_groups()))
	
	if body.is_in_group(self.get_groups()[0]) and self.get_instance_id() < body.get_instance_id():
		game_manager.on_fruits_collision(self, body, self.get_groups()[0])
		
