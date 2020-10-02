extends CanvasLayer

func _ready():
	var file = File.new()
	if file.file_exists("user://best_score.dat"):
		file.open("user://best_score.dat", File.READ)
		var content = file.get_as_text()
		file.close()
		$BestScore.text = "best score: %s" % content;

func play():
	queue_free()
	get_tree().change_scene("res://Scene/Game.tscn")

func shop():
	pass

