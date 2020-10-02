extends Area2D;

signal hit;

#tween used to animate
onready var h_tween = $Horizontal
onready var v_tween = $Vertical

#sound
onready var slide_sound = $SlidePlayer
onready var shape_sound = $ShapePlayer

#different shape sprite
onready var shape = {"circle":$circle,"square":$square,"star":$star};

#import of FallingShape
var FallingShape = preload("res://Script/FallingShape.gd");

#speed of the player
export var speed = 3;

#Vector2D used to calculated the direction of the slide
var move_start = Vector2(-1,-1);
var move_end = Vector2(-1,-1);

#the minimal distance to trigger a slide
const click_gap=10;

#The curent position on the screen (0,1,2) and the current position of the shape(0,1,2)
var line_position = 1;
var shape_position = 0;

#Space between two line
const mouvement_size = 240;var clicked = false;

func _input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			#If the screen is just pressed, reset the two vector
			move_start = Vector2(-1,-1);
			move_end = Vector2(-1,-1);
		else:
			#If the screen is not pressed anymore and if the move_start was not on his default state
			#Save the end position of the slide and calcul the difference between the two positions
			if move_start !=Vector2(-1,-1) : move_end=event.position
			var move_relative = move_end-move_start;
			#If that was a touch and not a slide, end the function
			if abs(move_relative.x) < click_gap && abs(move_relative.y) < click_gap: return;
			#Test if it's a vertical or a horizontal slide
			if abs(move_relative.x)>abs(move_relative.y):
				#Test direction of the slide
				if move_relative.x > 0:
					on_right();
				else:
					on_left();
			else:
				#Test direction of the slide
				if move_relative.y < 0:
					on_up();
				else:
					on_down();
	elif event is InputEventScreenDrag:
		#If there is no start position and we get a slide event, save the start position of the slide
		if move_start == Vector2(-1,-1):
			 move_start=event.position
	
func on_down():
	#Animation and action played when the direction is down (must haven't a vertical animation already played)
	if !v_tween.is_active():
		switch_shape(getUpShape(),getMiddleShape(),getDownShape(),Vector2.DOWN);
		
		shape_position=getDownShapePosition();
	
		changed_shape();
	
func on_up():
	#Action played when the direction is up (must haven't a vertical animation already played)
	if !v_tween.is_active():
		switch_shape(getDownShape(),getMiddleShape(),getUpShape(),Vector2.UP);
		
		shape_position=getUpShapePosition();
	
		changed_shape();

func switch_shape(edgeToMiddle:Sprite, middleToEdge:Sprite, edgeToEdge:Sprite, direction:Vector2):
	#The animation used to switch shape
	v_tween.interpolate_property(edgeToMiddle, "position",
		null, edgeToMiddle.position - Vector2(250,0) *direction.y,
		1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	v_tween.interpolate_property(edgeToMiddle, "scale",
		null, Vector2(1,1),
		1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	v_tween.interpolate_property(edgeToMiddle, "modulate",
		null, edgeToMiddle.modulate + Color(0,0,0,0.75),
		1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		
	v_tween.interpolate_property(middleToEdge, "position",
		null, middleToEdge.position - Vector2(250,0) * direction.y,
		1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	v_tween.interpolate_property(middleToEdge, "scale",
		null, Vector2(0.5,0.5),
		1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	v_tween.interpolate_property(middleToEdge, "modulate",
		null, middleToEdge.modulate - Color(0,0,0,0.75),
		1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		
	v_tween.interpolate_property(edgeToEdge, "position",
		null, edgeToEdge.position + Vector2(500,0) * direction.y,
		1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)

func changed_shape():
	#Things in common up right and down movement	
	shape_sound.play();
	v_tween.start();
	
	#if a falling shape is overlapping when changging the shape, recall the entered fonction
	for body in get_overlapping_bodies():
		if body is FallingShape:
			_on_Player_body_entered(body);

func on_left():
	#Animation and action played when the direction is left (must haven't a horizontal animation already played)
	#And the current position must not be on the far left line
	if !h_tween.is_active() && line_position>0:
		line_position-=1;
		slide(Vector2.LEFT);
		
func on_right():
	#Animation and action played when the direction is right (must haven't a horizontal animation already played)
	#And the current position must not be on the far right line
	if !h_tween.is_active() && line_position<2:
		line_position+=1;
		slide(Vector2.RIGHT);

func slide(v:Vector2):
	#Things in common between right and left movement	
	h_tween.interpolate_property(self, "position",
	null, position + v * mouvement_size,
	1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	
	h_tween.interpolate_property(getMiddleShape(), "rotation_degrees",
	null, getMiddleShape().rotation_degrees + 360*v.x,
	1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	
	slide_sound.play();
	h_tween.start();
				
func _on_Player_body_entered(body):
	#If the falling shape has the correct form, call hitted on the shape and emi the hit signal
	if body is FallingShape:
		if body.sprite == shape.keys()[shape_position]:
			body.hitted();
			emit_signal("hit");


func getUpShape():
	return shape.get(shape.keys()[getDownShapePosition()]);
	
func getMiddleShape():
	return shape.get(shape.keys()[shape_position]);
	
func getDownShape():
	return shape.get(shape.keys()[getUpShapePosition()]);
	
func getUpShapePosition():
	#Return the index of the current shape at the up position
	return shape_position+1 if shape_position+1 < shape.size() else 0;
	
func getDownShapePosition():
	#Return the index of the current shape at the down position
	return shape_position-1 if shape_position-1 >=0 else shape.size()-1;
