extends Area2D;

signal hit;

onready var h_tween = $Horizontal
onready var v_tween = $Vertical
onready var slide_sound = $SlidePlayer
onready var shape_sound = $ShapePlayer
onready var shape = {"circle":$circle,"square":$square,"star":$star};

var FallingShape = preload("res://Script/FallingShape.gd");

export var speed = 3;

var move_start = Vector2(-1,-1);
var move_end = Vector2(-1,-1);

var click_gap=10;

var line_position = 1;
var shape_position = 0;

var mouvement_size = 240;

var clicked = false;

func _input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			move_start = Vector2(-1,-1);
			move_end = Vector2(-1,-1);
		else:
			if move_start !=Vector2(-1,-1) : move_end=event.position
			var move_relative = move_end-move_start;
			if abs(move_relative.x)>abs(move_relative.y):
				if abs(move_relative.x) < click_gap: return;
				if move_relative.x > 0:
					on_right();
				else:
					on_left();
			else:
				if abs(move_relative.y) < click_gap: return;
				if move_relative.y < 0:
					on_up();
				else:
					on_down();
	elif event is InputEventScreenDrag:
		if move_start == Vector2(-1,-1):
			 move_start=event.position
	
func on_down():
	if !v_tween.is_active():
		v_tween.interpolate_property(getUpShape(), "position",
			null, getUpShape().position - Vector2(250,0),
			1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		v_tween.interpolate_property(getUpShape(), "scale",
			null, Vector2(1,1),
			1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		v_tween.interpolate_property(getUpShape(), "modulate",
			null, getUpShape().modulate + Color(0,0,0,0.75),
			1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		
		v_tween.interpolate_property(getMiddleShape(), "position",
			null, getMiddleShape().position - Vector2(250,0),
			1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		v_tween.interpolate_property(getMiddleShape(), "scale",
			null, Vector2(0.5,0.5),
			1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		v_tween.interpolate_property(getMiddleShape(), "modulate",
			null, getMiddleShape().modulate - Color(0,0,0,0.75),
			1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
			
		v_tween.interpolate_property(getDownShape(), "position",
			null, getDownShape().position + Vector2(500,0),
			1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		
		shape_position=downShapePosition();
	
		changed_shape();
	
func on_up():
	if !v_tween.is_active():
		v_tween.interpolate_property(getDownShape(), "position",
			null, getDownShape().position + Vector2(250,0),
			1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		v_tween.interpolate_property(getDownShape(), "scale",
			null, Vector2(1,1),
			1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		v_tween.interpolate_property(getDownShape(), "modulate",
			null, getDownShape().modulate + Color(0,0,0,0.75),
			1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		
		v_tween.interpolate_property(getMiddleShape(), "position",
			null, getMiddleShape().position + Vector2(250,0),
			1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		v_tween.interpolate_property(getMiddleShape(), "scale",
			null, Vector2(0.5,0.5),
			1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		v_tween.interpolate_property(getMiddleShape(), "modulate",
			null, getMiddleShape().modulate - Color(0,0,0,0.75),
			1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
			
		v_tween.interpolate_property(getUpShape(), "position",
			null, getUpShape().position - Vector2(500,0),
			1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		
		shape_position=upShapePosition();
	
		changed_shape();

func on_left():
	if !h_tween.is_active() && line_position>0:
		line_position-=1;
		h_tween.interpolate_property(self, "position",
		null, position + Vector2.LEFT * mouvement_size,
		1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		h_tween.interpolate_property(getMiddleShape(), "rotation_degrees",
		null, getMiddleShape().rotation_degrees - 360,
		1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)	
		slide();
		
func on_right():
	if !h_tween.is_active() && line_position<2:
		line_position+=1;
		h_tween.interpolate_property(self, "position",
		null, position + Vector2.RIGHT * mouvement_size,
		1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		h_tween.interpolate_property(getMiddleShape(), "rotation_degrees",
		null, getMiddleShape().rotation_degrees + 360,
		1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		slide();

func slide():
	slide_sound.play();
	h_tween.start();

func changed_shape():
	shape_sound.play();
	v_tween.start();
	for body in get_overlapping_bodies():
		if body.sprite == shape.keys()[shape_position]:
			body.hitted();
			emit_signal("hit");
				
func _on_Player_body_entered(body):
	if body is FallingShape:
		if body.sprite == shape.keys()[shape_position]:
			body.hitted();
			emit_signal("hit");

func getUpShape():
	return shape.get(shape.keys()[downShapePosition()]);
	
func getMiddleShape():
	return shape.get(shape.keys()[shape_position]);
	
func getDownShape():
	return shape.get(shape.keys()[upShapePosition()]);
	
func upShapePosition():
	var new_shape_position = shape_position+1;
	if new_shape_position >= shape.size():
		new_shape_position = 0
	return new_shape_position;
	
func downShapePosition():
	var new_shape_position = shape_position-1;
	if new_shape_position < 0:
		new_shape_position = shape.size()-1
	return new_shape_position;
