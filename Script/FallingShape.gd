extends KinematicBody2D;

onready var spriteElement = $Sprite; #The sprite
onready var tween = $Tween; #Tween for animation
onready var audio = $AudioStreamPlayer2D; #AudioStreamPlayer to manage sound

export(String) var sprite; #sprite name for the shape
export var speed = 1 ;#Speed of the shape

# Called when the node enters the scene tree for the first time.
func _ready():
	#Load the appriopriate sprite
	$Sprite.texture = load("res://Sprite/Default/Obstacle/"+sprite+".png");
	#Play the rainbow animation
	$Sprite/AnimationPlayer.play("rainbow");
	
func _process(delta):
	#Make the shape moving to the bottom
	self.position+= Vector2(0,speed);
	
func hitted():
	#When the shape is collided play this animation and a sound.
	
	#Scale animation
	tween.interpolate_property(spriteElement, "scale",
			null, spriteElement.scale + Vector2(10,10),
			1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	
	#Transparency animation
	tween.interpolate_property(spriteElement, "modulate",
			null, spriteElement.modulate - Color(0,0,0,1),
			1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
			
	tween.start();
	
	#Play the sound with a random pitch
	audio.play();
	audio.pitch_scale = rand_range(0.5,2);

func _on_Tween_tween_all_completed():
	#When the animation is finished, free the memory space of the object
	queue_free()
