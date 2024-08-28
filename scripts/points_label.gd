extends Label

func _ready():
	GameManager.points_updated.connect(points_updated)

func points_updated(new_points : int):
	self.text = "Points : " + str(new_points)
