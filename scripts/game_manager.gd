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

""" Signal to broadcast upon points updation """
signal points_updated(new_points)

func _ready():
	fruits_parent = get_node("/root/Node2D/FruitSpawner")

#func _process(delta):
	#if not fruits_parent:
		#fruits_parent = get_node("/root/Node2D/FruitSpawner")
		#

"""
Get the next fruit name in the cycle for fusions 
This function should never fire on the watermelon we check for it anyways
"""
func get_next_fruit_id(fruit_id):
	assert(fruit_id != "watermelon", "Trying to fuse watermelons!")
	return fruit_names[fruit_names.find(fruit_id) + 1]

"""
Get a random new fruit scene to spawn at the fruit_spawner marker
Only choose from the first 5 fuits (cheery to persimmon)
"""
func get_random_new_fruit_scene():
	# slice returns elements from 0 (inclusive) to 5 (exclusive)
	return fruit_scenes[fruit_names.slice(0,5).pick_random()]

"""
Add some points based on the new fruit spawned
"""
func add_points(fruit_id):
	points += friuit_points[fruit_id]
	points_updated.emit(points)

"""
Spawn a new fruit as a result of collision between two of the same fruits
"""
func new_fruit_from_collision(old_fruit_id, old_position, old_fruit):	
	# instantiate a new fruit based on the next fruit_id
	var new_fruit = fruit_scenes[get_next_fruit_id(old_fruit_id)].instantiate()
	
	# add the new fruit to the scene tree
	fruits_parent.call_deferred("add_child", new_fruit) 
	
	# set the fruit's position to the current fruit's position
	new_fruit.set_deferred("global_position", old_position)
	
	
	
