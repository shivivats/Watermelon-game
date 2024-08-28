extends Node2D

# Probabilities to spawn fruits
# Must add to 1
var fruit_chances = {
	"apple" : 0.2, 
	"strawberry" : 0.2, 
	"grapes" : 0.2, 
	"orange" : 0.2, 
	"clementine" : 0.1, 
	"tomato" : 0.1, 
	#"melon", "peach", "pineapple", "greenmelon", "watermelon"
}

var current_fruit = null

@onready var game_manager = %GameManager
@onready var fruits_parent = %FruitsParent


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("temp_new_fruit"):
		make_fruit("strawberry")

func _input(event):
	if event is InputEventScreenTouch:
		print("Screen Click/Unclick at: ", event.position)
	elif event is InputEventScreenDrag:
		print("Screen Drag at: ", event.position)
		
	# Print the size of the viewport.
		print("Viewport Resolution is: ", get_viewport().get_visible_rect().size)


func get_next_fruit():
	var rando = randf_range(0,1)
	for fruit_name in fruit_chances:
		rando -= fruit_chances[fruit_name]
		if rando <= 0:
			make_fruit(fruit_name)
			break

func make_fruit(fruit_name):
	var spawned_fruit = game_manager.fruit_dict[fruit_name].instantiate()
	
	spawned_fruit.global_position = $Marker2D.global_position
	fruits_parent.add_child(spawned_fruit)
	
