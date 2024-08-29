extends Node2D

""" Hard-coded references """
@onready var fruits_parent: Node = %FruitsParent

@onready var fruit_box: StaticBody2D = $"../Camera2D/FruitBox"

@onready var release_timer: Timer = $ReleaseTimer
@onready var spawn_timer: Timer = $SpawnTimer

var release_cooldown = false

var held_fruit = null

""" Default next fruit id is strawberry """
var next_fruit_id = "strawberry"

""" Reference for next_fruit_sprite """
@onready var next_fruit_sprite: Sprite2D = $"../NextFruitBox/NextFruitSprite"

""" World boundary references set in _ready """
var world_boundary_left = null
var world_boundary_right = null

""" Offset from the world boundaries"""
@export var boundary_offset = 100

""" True when we're taking user input """
var can_input = true

"""
Ran at the start of the scene.
"""
func _ready() -> void:
	# set the world boundaries from fruit box
	world_boundary_left = fruit_box.get_node("WorldBoundaryLeft")
	world_boundary_right = fruit_box.get_node("WorldBoundaryRight")
	
	# make a new held fruit at the marker
	new_held_fruit()
	
	# subscribe to the disable input event from GameManager
	GameManager.disable_input.connect(update_can_input)

	GameManager.new_held_fruit.connect(new_held_fruit)

"""
Runs every frame.
"""
func _process(delta: float) -> void:
	# if we have a held_fruit, then keep its position updated
	if held_fruit: 
		held_fruit.global_position = self.global_position

"""
Update the can_input variable
Currently only happens when the game ends
"""
func update_can_input(new_can_input):
	self.can_input = new_can_input

"""
Release the current held fruit
"""
func release_fruit():
	
	# condition here for release builds (for now. the game should never be released if the assert above is being fired)
	if not held_fruit:
		return
	
	# remove the physics freeze from the rigidbody
	held_fruit.freeze = false 
	
	# set the collision to false
	held_fruit.get_node("CollisionShape2D").set_deferred("disabled", false)

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
	
	# if we're already holding a fruit then dont do anything
	if held_fruit:
		return
	
	assert(next_fruit_id, "Next fruit ID not set!!!")
	
	# get the next fruit object from the game master
	held_fruit = GameManager.get_new_fruit_scene(next_fruit_id).instantiate()
	
	# set the fruit's position to the position of the fruit spawner marker
	held_fruit.global_position = self.global_position 
	
	# freeze the fruit's rigidbody physics
	held_fruit.freeze = true 
	
	held_fruit.latest_fruit = true
	
	#held_fruit.get_node("CollisionPolygon2D").set_deferred("disabled", true)
	held_fruit.get_node("CollisionShape2D").set_deferred("disabled", true)
	
	# attach the fruit to the fruits_parent object in the scene tree
	fruits_parent.call_deferred("add_child",held_fruit) 
	
	# update the offset of the fruit_spawner marker from the world edges
	update_boundary_offset()
	
	# update the "upcoming" next fruit sprite
	update_next_fruit_sprite()

"""
Update the next fruit sprite
"""
func update_next_fruit_sprite():
	# get a random fruit ID from the game manager as the next fruit id
	next_fruit_id = GameManager.get_random_new_fruit_name()
	
	# update the next fruit sprite
	next_fruit_sprite.texture = GameManager.fruit_sprites[next_fruit_id]


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
	#new_held_fruit()
	pass

"""
Helper function to set self position after all the calcs
"""
func update_self_position(new_position):
	# Clamp self position between world boundaries with offsets
	self.global_position.x = clamp(new_position.x,
		world_boundary_left.global_position.x + boundary_offset,
		world_boundary_right.global_position.x - boundary_offset
		)



"""
Helper function to update boundary offset based on the current held fruit
"""
func update_boundary_offset():
	if not held_fruit:
		return
	
	# update the boundary offset based on the current held fruit's collision shape radius
	boundary_offset = held_fruit.get_node("CollisionShape2D").shape.radius
	
	# update the self position again
	update_self_position(self.global_position)

"""
This is NOT a function directly connected to this script.
It gets called from the fruit_box when that detects input.
Manages moving and releasing the fruit
"""
func on_fruit_box_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if not can_input:
		return
	
	if event is InputEventScreenTouch: # if the user touches the screen
		#print("Screen/Mouse touch at " + str(event.position))
		
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
	if not can_input:
		return
	if event is InputEventScreenDrag:
		#print("Screen/Mouse drag at " + str(event.position))
		
		# move the fruit_spawner's x position to match the drag position.
		# the held_fruit's position will be moved to match in _process()
		update_self_position(get_canvas_transform().affine_inverse().translated(event.position).origin)		
