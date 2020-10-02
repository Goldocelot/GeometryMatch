extends CanvasLayer

func _ready():
	#Load the best score of the player

	var file = File.new()
	if file.file_exists("user://best_score.dat"):
		file.open("user://best_score.dat", File.READ)
		var content = file.get_as_text()
		file.close()
		$BestScore.text = "best score: %s" % content;

func play():
	#Start game
	queue_free()
	get_tree().change_scene("res://Scene/Game.tscn")

func shop():
	#Coming soon
	pass

