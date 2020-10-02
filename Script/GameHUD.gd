extends CanvasLayer;

onready var resume_timer = $ResumTimer;
onready var resume = $Resum;
onready var resume_animation = $Resum/AnimationPlayer;

var score = 0;
const pause_time=6

var current_pause=0;

func _ready():
	resume.hide();

func increaseScore(amount):
	score+=amount;
	$Score.text = String(score);


func _on_Pause_pressed():
	get_tree().paused=true;
	if current_pause == 0:
		current_pause=pause_time;
	else:
		resume_timer.start();
		resume.text = String(current_pause/2);
		resume.show();


func _on_ResumTimer_timeout():
	current_pause-=1;
	if current_pause%2==0:
		resume.text = String(current_pause/2);
	else:
		resume_animation.play("nextSecond");
		
	if current_pause == 0:
		get_tree().paused=false;
		resume_timer.stop();
		resume.hide();


func _on_AnimationPlayer_animation_finished(anim_name):
	resume.rect_scale=Vector2(1,1);
