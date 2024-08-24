extends Node

# Manage new fruit spawns
# Make fusions happen, i.e., keep track of what comes after %GameManagerwork
# Keep track of the score

const fruit_list = ["apple", "strawberry", "grapes", "orange", "clementine", "tomato", "melon", "peach", "pineapple", "greenmelon", "watermelon"]

var fruit_dict = {
	"apple" : load("res://scenes/fruit_0apple.tscn"),
	"strawberry" : load("res://scenes/fruit_1strawberry.tscn"),
	"grapes" : load("res://scenes/fruit_2grapes.tscn"),
	"orange" : load("res://scenes/fruit_3orange.tscn"),
	"clementine" : load("res://scenes/fruit_4clementine.tscn"),
	"tomato" : load("res://scenes/fruit_5tomato.tscn"),
	"melon" : load("res://scenes/fruit_6melon.tscn"),
	"peach" : load("res://scenes/fruit_7peach.tscn"),
	"pineapple" : load("res://scenes/fruit_8pineapple.tscn"),
	"greenmelon" : load("res://scenes/fruit_9greenmelon.tscn"),
	"watermelon" : load("res://scenes/fruit_10watermelon.tscn")
}


@onready var fruits_parent = %FruitsParent



func on_fruits_collision(fruit1, fruit2, fruitName):
	print("fruits collided!")
	# fruits are guaranteed to have same tags
	print(str(fruitName))
	
	# spawn a new fruit at the average location of the two fruits
	var next_index = 0
	if not fruit_list.find(fruitName) == fruit_list.size() - 1:
		next_index = fruit_list.find(fruitName)+1
	var next_fruit_name = fruit_list[next_index]
	var spawned_fruit = fruit_dict[next_fruit_name].instantiate()
	
	var pos1 = fruit1.global_position
	var pos2 = fruit2.global_position
	
	fruit1.queue_free()
	fruit2.queue_free()
	
	fruits_parent.add_child(spawned_fruit)
	
	#spawned_fruit.global_position = Vector2((pos1.x + pos2.x)/2, (pos1.y + pos2.y)/2 )
	
	spawned_fruit.global_position = pos2
	

