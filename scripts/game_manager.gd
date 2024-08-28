extends Node

# Manage new fruit spawns
# Make fusions happen, i.e., keep track of what comes after %GameManagerwork
# Keep track of the score

const fruit_list = ["apple", "strawberry", "grapes", "orange", "clementine", "tomato", "melon", "peach", "pineapple", "greenmelon", "watermelon"]

var fruit_dict = {
	"apple" : load("res://scenes/fruit_apple.tscn"),
	"strawberry": load("res://scenes/fruit_strawberry.tscn"),
}


@onready var fruits_parent = %FruitsParent



func on_fruits_collision(fruit1, fruit2, fruitName):
	print("fruits collided!")
	# fruits are guaranteed to have same tags
	print(str(fruitName))
	
	# spawn a new fruit at the average location of the two fruits
	var spawned_fruit = fruit_dict["strawberry"].instantiate()
	
	var pos1 = fruit1.global_position
	var pos2 = fruit2.global_position
	
	fruit1.queue_free()
	fruit2.queue_free()
	
	fruits_parent.add_child(spawned_fruit)
	
	#spawned_fruit.global_position = Vector2((pos1.x + pos2.x)/2, (pos1.y + pos2.y)/2 )
	
	spawned_fruit.global_position = pos2
	
