extends Label

func _ready():
	self.text = "Best: " + str(GameManager.highscore)
