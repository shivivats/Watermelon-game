extends Node2D

@onready var fruits_parent: Node = %FruitsParent

@onready var release_timer: Timer = $ReleaseTimer
@onready var spawn_timer: Timer = $SpawnTimer

var release_cooldown = false
var held_fruit = null

var held_polygon_disabled_default = false
var held_shape_disabled_default = false


"""
Ran at the start of the scene.
"""
func _ready() -> void:
	# make a new held fruit at the marker
	new_held_fruit()

"""
Runs every frame.
"""
func _process(delta: float) -> void:
	# if we have a held_fruit, then keep its position updated
	if held_fruit: 
		held_fruit.global_position = self.global_position
	
"""
Release the current held fruit
"""
func release_fruit():
	
	# make absolutely sure that we have a held_fruit!!
	assert(held_fruit, "No held fruit!!")
	
	# condition here for release builds (for now. the game should never be released if the assert above is being fired)
	if not held_fruit:
		pass
	
	# make sure the fruit's release position is updated!
	#held_fruit.global_position.x = position.x 
	
	# remove the physics freeze from the rigidbody
	held_fruit.freeze = false 
	
	# set the collisions back to default
	held_fruit.get_node("CollisionPolygon2D").set_deferred("disabled", held_polygon_disabled_default)
	held_fruit.get_node("CollisionShape2D").set_deferred("disabled", held_shape_disabled_default)
	held_polygon_disabled_default = false
	held_shape_disabled_default = false
	
	# remove our reference to the held fruit so we stop updating it in _process and are ready for a new held fruit
	held_fruit = null 
	
	# start the spawn_timer that waits to spawn a new fruit
	spawn_timer.start()
	
	# set the release_cooldown which prevents us from releasing multiple fruits very very quickly
	release_cooldown = true
	
	# set the release_timer to reset the release_cooldown after a bit
	release_timer.start()


"""
Spawn a new held fruit at the fruit_spawner marker
"""
func new_held_fruit():
	# get a random fruit object from the game master
	held_fruit = GameManager.get_random_new_fruit_scene().instantiate()
	
	# set the fruit's position to the position of the fruit spawner marker
	held_fruit.global_position = self.global_position 
	
	# freeze the fruit's rigidbody physics
	held_fruit.freeze = true 
	
	# disable the collision on the held_fruit as well
	held_polygon_disabled_default = held_fruit.get_node("CollisionPolygon2D").is_disabled()
	held_shape_disabled_default = held_fruit.get_node("CollisionShape2D").is_disabled()
	
	held_fruit.get_node("CollisionPolygon2D").set_deferred("disabled", true)
	held_fruit.get_node("CollisionShape2D").set_deferred("disabled", true)
	
	# attach the fruit to the fruits_parent object in the scene tree
	fruits_parent.add_child(held_fruit) 

"""
When release timer elapses.
"""
func _on_release_timer_timeout() -> void:
	# set release_cooldown to false to let player release fruits again
	release_cooldown = false
	
"""
When spawn timer elapses.
"""
func _on_spawn_timer_timeout() -> void:
	# Spawn a new held_fruit upon spawn cooldown ending
	new_held_fruit()

"""
This is NOT a function directly connected to this script.
It gets called from the fruit_box when that detects input.
Manages moving and releasing the fruit
"""
func on_fruit_box_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventScreenDrag: # if the user drags on the screen
		print("Screen/Mouse drag at " + str(event.position))
		# move the fruit_spawner's x position to match the drag position.
		# the held_fruit's position will be moved to match in _process()
		var screen_position = get_canvas_transform().affine_inverse().translated(event.position).origin
		self.global_position.x = screen_position.x
		
	elif event is InputEventScreenTouch: # if the user touches the screen
		print("Screen/Mouse touch at " + str(event.position))
		
		# if we can release the fruit, then release it at the correctly transformed screen position
		if not release_cooldown:
			release_fruit()
		else:
			# TODO: Add some VFX and SFX and maybe even vibrations here to let the user know they cant release a fruit
			print("Release cooldown!")
		
"""
General input function to handle events even outside of the fruit_box area
Will only handle moving the fruit_spawner object, not releasing the fruit.
"""
# https://forum.godotengine.org/t/godot-3-0-2-get-global-position-from-touchscreen/27397/4
func _input(event : InputEvent) -> void:
	if event is InputEventScreenDrag:
		#print("Screen drag at " + str(event.position))
		self.global_position.x = get_canvas_transform().affine_inverse().translated(event.position).origin.x
	elif event is InputEventScreenTouch:
		print("Screen touch at : " + str(event.position))
		
