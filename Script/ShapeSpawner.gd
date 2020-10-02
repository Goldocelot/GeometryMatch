extends Node2D

export(Array) var positions;

onready var timer = $Timer;

export var speed=1.0;

var FallingShape = preload("res://GameObject/FallingShape.tscn");
var shape = ["circle","square","star"];

var last_shape=0;
var last_position=0;

func _ready():
	timer.set_wait_time(1.0/speed * 3.0);
	timer.start();

func _on_Timer_timeout():
	var rand_shape = last_shape;
	var rand_position = last_position;
	
	while rand_shape==last_shape and rand_position==last_position:
		rand_shape = randi() % shape.size();
		rand_position = randi() % positions.size();
			
	var rand_time = (randi() % 26)/10.0;
	var falling = FallingShape.instance();
	falling.sprite =shape[rand_shape];
	falling.position = positions[rand_position];
	falling.speed = speed*1.5;
	add_child(falling);
	last_shape=rand_shape;
	last_position=rand_position;
	timer.set_wait_time(1.0/speed * 3.0 + rand_time/speed);
	timer.start();
