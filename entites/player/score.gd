extends Label

func _process(_delta):
	self.text = str(GameManager.get_score())
