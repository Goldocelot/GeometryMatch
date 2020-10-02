extends Node2D

onready var player = $Player;
onready var spawner = $Spawner;
onready var camera = $CameraShake;
onready var hud = $GameHUD;
onready var background_sound = $BackGround;

export var speed=1;
export var max_speed=36;

var best_score=0;
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize();
	player.speed=pow(speed,1.0/3);
	spawner.speed=pow(speed,1.0/3);
	
	var file = File.new()
	file.open("user://best_score.dat", File.READ)
	best_score = int(file.get_as_text())
	file.close()

func increase_speed():
	if speed+1<=max_speed:
		speed+=1;
		player.speed=pow(speed,1.0/3);
		spawner.speed=pow(speed,1.0/3);
		background_sound.pitch_scale = 0.002*speed + 0.9841;

func _on_Player_hit():
	increase_speed();
	camera.add_trauma(1);
	camera.shake();
	hud.increaseScore(1);

func _on_LoseArea_body_entered(body):
	var score = hud.score;	

	if score > best_score:
		var file = File.new();
		file.open("user://best_score.dat", File.WRITE);
		file.store_string(String(hud.score));
		file.close();
	
	queue_free();
	get_tree().change_scene("res://Scene/Menu/MenuHUD.tscn");
	


func _on_BackGround_finished():
	background_sound.play()

