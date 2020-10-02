extends Node2D

#Position where the spawner can spawn shape
export(Array) var positions;

#Time betwwen 2 spawn
onready var timer = $Timer;

#Spawn speed
export var speed=1.0;

#Preloading of the fallingShape prefab
var FallingShape = preload("res://GameObject/FallingShape.tscn");
#List of shape name
var shape = ["circle","square","star"];

#index of the last shape and the last position
var last_shape=0;
var last_position=0;

func _ready():
	#Init and start the timer
	timer.set_wait_time(1.0/speed * 3.0);
	timer.start();

func _on_Timer_timeout():
	#Creation of randome variable and storage of unwanted walue to be sure one of the two is gonna be different after the
	#while 
	var rand_shape = last_shape;
	var rand_position = last_position;
	
	#Generate random line and random shape
	while rand_shape==last_shape and rand_position==last_position:
		rand_shape = randi() % shape.size();
		rand_position = randi() % positions.size();
			
	#Generate a randome time before the next spawn
	var rand_time = (randi() % 26)/10.0;
	
	#Instanciate the falling shape, setting the random position, shape and the current game speed
	var falling = FallingShape.instance();
	falling.sprite =shape[rand_shape];
	falling.position = positions[rand_position];
	falling.speed = speed*1.5;
	add_child(falling);
	
	#Store the new last value and start the timer for the next shape
	last_shape=rand_shape;
	last_position=rand_position;
	timer.set_wait_time(1.0/speed * 3.0 + rand_time/speed);
	timer.start();
