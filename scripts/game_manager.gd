extends Node

@onready var fruits_parent: Node = null

""" A ordered array of all fruit names """ 
const fruit_names = [
	"cherry",
	"strawberry",
	"grapes",
	"dekopon",
	"persimmon",
	"apple",
	"pear",
	"peach",
	"pineapple",
	"melon",
	"watermelon" 
]

const fruit_sprites = {
	"cherry" : preload("res://assets/sprites/fruits/0_cherry.png"),
	"strawberry" : preload("res://assets/sprites/fruits/1_strawberry.png"),
	"grapes" : preload("res://assets/sprites/fruits/2_grapes.png"),
	"dekopon" : preload("res://assets/sprites/fruits/3_dekopon.png"),
	"persimmon" : preload("res://assets/sprites/fruits/4_persimmon.png"),
	"apple" : preload("res://assets/sprites/fruits/5_apple.png"),
	"pear" : preload("res://assets/sprites/fruits/6_pear.png"),
	"peach" : preload("res://assets/sprites/fruits/7_peach.png"),
	"pineapple" : preload("res://assets/sprites/fruits/8_pineapple.png"),
	"melon" : preload("res://assets/sprites/fruits/9_melon.png"),
	"watermelon"  : preload("res://assets/sprites/fruits/10_watermelon.png")
}

""" A dict containing the points each fruit gives upon being fused into """ 
const friuit_points = {
	"cherry" : 1,
	"strawberry" : 3,
	"grapes" : 6,
	"dekopon" : 10,
	"persimmon" : 15,
	"apple" : 21,
	"pear" : 28,
	"peach" : 36,
	"pineapple" : 45,
	"melon" : 55,
	"watermelon" : 66 
}

""" A dict containing each fruit's respective scenes """
const fruit_scenes = {
	"cherry" : preload("res://scenes/fruits/fruit_0_cherry.tscn"),
	"strawberry" : preload("res://scenes/fruits/fruit_1_strawberry.tscn"),
	"grapes" : preload("res://scenes/fruits/fruit_2_grapes.tscn"),
	"dekopon" : preload("res://scenes/fruits/fruit_3_dekopon.tscn"),
	"persimmon" : preload("res://scenes/fruits/fruit_4_persimmon.tscn") ,
	"apple" : preload("res://scenes/fruits/fruit_5_apple.tscn"),
	"pear" : preload("res://scenes/fruits/fruit_6_pear.tscn"),
	"peach" : preload("res://scenes/fruits/fruit_7_peach.tscn"),
	"pineapple" : preload("res://scenes/fruits/fruit_8_pineapple.tscn"),
	"melon" : preload("res://scenes/fruits/fruit_9_melon.tscn"),
	"watermelon" : preload("res://scenes/fruits/fruit_10_watermelon.tscn") 
}

""" Current points the player has gathered """
var points = 0

""" Player's current highscore """
var highscore = 0

""" Highscore File location """
const highscore_file = "user://highscore.txt"

""" Signal to broadcast upon points updation """
signal points_updated(new_points)

# TODO: scale magnitude based on fruit size
@export var explosion_magnitude = 35000

""" The explosion signal when the fruits collide """
signal fruits_explosion(position, magnitude)

""" Signal sent out to spawn new held fruit """
signal new_held_fruit()

""" Set input signal for when the game end UI pops up"""
signal set_input(can_input)

func _ready():
	# find fruits_parent dynamically
	fruits_parent = get_node("/root/Node2D/FruitsParent")
	
	# update the points text with default value
	points_updated.emit(points)
	
	# update highscore text with default values
	load_highscore()

#func _process(delta):
	#if Input.is_action_just_pressed("test"):
		#store_highscore()
		
"""
Store the highscore when the app is paused,
	the user clicks the back button (which quits the app),
	or the close request is given (which doesnt work on android but might as well)
https://docs.godotengine.org/en/stable/tutorials/inputs/handling_quit_requests.html
"""
func _notification(what):
	if what == NOTIFICATION_APPLICATION_PAUSED or NOTIFICATION_WM_GO_BACK_REQUEST or NOTIFICATION_WM_CLOSE_REQUEST:
		store_highscore()

"""
Get the next fruit name in the cycle for fusions 
This function should never fire on the watermelon but we check for it anyways
"""
func get_next_fruit_id(fruit_id):
	assert(fruit_id != "watermelon", "Trying to fuse watermelons!")
	return fruit_names[fruit_names.find(fruit_id) + 1]
	
	
"""
Get a random new fruit name to show up as the next fruit to be spawned
Only choose from the first 5 fuits (cheery to persimmon)
"""
func get_random_new_fruit_name():
	# slice returns elements from 0 (inclusive) to 5 (exclusive)
	return fruit_names.slice(0,5).pick_random()
	#return fruit_names.pick_random()
	

"""
Get a new fruit scene to spawn at the fruit_spawner marker
Based on the random fruit name generated earlier
"""
func get_new_fruit_scene(fruit_id):
	return fruit_scenes[fruit_id]

"""
Add some points based on the new fruit spawned
"""
func add_points(fruit_id):
	points += friuit_points[fruit_id]
	points_updated.emit(points)

"""
Spawn a new fruit as a result of collision between two of the same fruits
"""
func new_fruit_from_collision(old_fruit_id, old_position):	
	# instantiate a new fruit based on the next fruit_id
	var new_fruit = fruit_scenes[get_next_fruit_id(old_fruit_id)].instantiate()
	
	# add the new fruit to the scene tree
	fruits_parent.call_deferred("add_child", new_fruit) 
	
	# set the fruit's position to the current fruit's position
	new_fruit.set_deferred("global_position", old_position)
	
	# send signal to fruits to "explode"
	fruits_explosion.emit(old_position, explosion_magnitude)
	
	
# upon game start, load the highscore
func load_highscore():
	if not FileAccess.file_exists(highscore_file):
		highscore = 0
		print("getting default highscore aka 0")
	else:
		var file = FileAccess.open(highscore_file, FileAccess.READ)
		var content = file.get_as_text(true)
		print("read file contents " + content)
		highscore = int(content)
		print("highscore is " + str(highscore))
		file.close()
	
# upon game end, check if the current score is higher than the highscore, then save it
func store_highscore():
	print("Game end points are " + str(points) + " and highscore is " + str(highscore))
	if points > highscore:
		var file = FileAccess.open(highscore_file, FileAccess.WRITE)
		file.store_string(str(points))
		file.close()


func game_ended():
	store_highscore()
	set_input.emit(false)


func make_new_held_fruit():
	new_held_fruit.emit()
