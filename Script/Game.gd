extends Node2D

onready var player = $Player; #The representation of the player controller
onready var spawner = $Spawner; #The element used to spawn shape
onready var camera = $CameraShake; #The camera capable of shaking
onready var hud = $GameHUD; #The hud with the pause button and the score
onready var background_sound = $BackGround; #AudioStreamPlayer used to manage background sound

export var speed=1;
export var max_speed=36;

var best_score=0;
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize();
	#Init the shape spawner speed and the player speed based on the game speed
	player.speed=pow(speed,1.0/3);
	spawner.speed=pow(speed,1.0/3);
	
	#Load the player best score
	var file = File.new()
	file.open("user://best_score.dat", File.READ)
	best_score = int(file.get_as_text())
	file.close()

func increase_speed():
	#Checking if increase the speed is possible
	if speed+1<=max_speed:
		#If it's possible increase the speed of the game and of all his elements.
		speed+=1;
		player.speed=pow(speed,1.0/3);
		spawner.speed=pow(speed,1.0/3);
		background_sound.pitch_scale = 0.002*speed + 0.9841;

func _on_Player_hit():
	#When the player hit a shape, increase the speed, the score and shake the camera
	increase_speed();
	camera.add_trauma(1);
	camera.shake();
	hud.increaseScore(1);

func _on_LoseArea_body_entered(body):
	#When the player lose, save his score if it's his new best score and load the main menu.
	var score = hud.score;	

	if score > best_score:
		var file = File.new();
		file.open("user://best_score.dat", File.WRITE);
		file.store_string(String(hud.score));
		file.close();
	
	queue_free();
	get_tree().change_scene("res://Scene/Menu/MenuHUD.tscn");
	


func _on_BackGround_finished():
	#Play the background sound in loop
	background_sound.play()

