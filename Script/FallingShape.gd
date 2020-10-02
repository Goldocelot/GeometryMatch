extends KinematicBody2D;

onready var spriteElement = $Sprite;
onready var tween = $Tween;
onready var audio = $AudioStreamPlayer2D;

export(String) var sprite;
export var speed = 1;

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.texture = load("res://Sprite/Default/Obstacle/"+sprite+".png");
	$Sprite/AnimationPlayer.play("rainbow");
	
func _process(delta):
	self.position+= Vector2(0,speed);
	
func hitted():
	tween.interpolate_property(spriteElement, "scale",
			null, spriteElement.scale + Vector2(10,10),
			1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
			
	tween.interpolate_property(spriteElement, "modulate",
			null, spriteElement.modulate - Color(0,0,0,1),
			1.0/speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
			
	tween.start();
	audio.play();
	audio.pitch_scale = rand_range(0.5,2);

func _on_Tween_tween_all_completed():
	queue_free()
