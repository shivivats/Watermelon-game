"""
Checklist for new fruit instances:
	- Change the root node name from "fruit" to whatever fruit this is
	- Go to the root node and update the "fruit id"
	- Do "make sub-resources unique" on the collision shape or polygon
	- Change the sprite scale
	- Move the sprite position to 0!
	- Change the sprite location to be in the center
	- Make the sprite sub-resource unique as well!
	- Make sure the correct collision shape or polygon is enabled and visible!!
"""

extends RigidBody2D

""" publically exposed fruit_id and angular_torque to be set individually on the fruit instances """
@export var fruit_id = "fruit"
@export var angular_torque = 50

""" Set some fruit values based on the exposed parameters """
func set_fruit_values():
	# add the fruit to the global group with the fruit_id name
	# this is used in collision checking later
	add_to_group(fruit_id)

""" Set the fruit values upon the start of the game as well """
func _ready() -> void:
	set_fruit_values()
	GameManager.fruits_explosion.connect(explode)

""" Return the fruit_id """
func get_fruit_id():
	return fruit_id

""" Explode the fruit upon signal from GameManager"""
func explode(position, magnitude):
	# get distance of self to combination position aka explosion center
	var distance = self.global_position.distance_to(position)
	
	# get direction from self to combination position aka explosion center
	var direction = (self.global_position - position).normalized()
	
	# divide with distance here to have fruits further away have less explosive power
	# multiply with explosion magnitude
	self.apply_central_impulse(direction * magnitude / distance)

""" 
Connected to the RigidBody, detects collisions on the respective shape
"""
func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	# just dont do anything if we or the other body is a watermelon
	if body.is_in_group("watermelon") or self.is_in_group("watermelon"):
		return
		
	# check for same group (aka same fruit) and only do the rest on one of the two colliding bodies
	if body.is_in_group(fruit_id) and self.get_instance_id() < body.get_instance_id():
		print("collided!")
		print(body.get_groups())
		
		# add points accodingly
		GameManager.add_points(GameManager.get_next_fruit_id(fruit_id))
		
		# delete the other body
		body.queue_free()
		
		# spawn a new fruit at this location 
		GameManager.new_fruit_from_collision(fruit_id, self.global_position)
		
		# delete self
		self.queue_free()
