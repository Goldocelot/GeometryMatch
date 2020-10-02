extends CanvasLayer;

onready var resume_timer = $ResumTimer; #Timer used to do the resum cooldown
onready var resume = $Resum; #Label used to display the cooldown
onready var resume_animation = $Resum/AnimationPlayer; #AnimationPlayer used to animate the cooldown

var score = 0; #Current score of the player
const pause_time=6 #The start time of the cooldown (in 0.5 second)

var current_pause=0; #The current time of the cooldown

func _ready():
	#Hide the resume label
	resume.hide();

func increaseScore(amount):
	#Increase the score
	score+=amount;
	$Score.text = String(score);


func _on_Pause_pressed():
	#Pause the game
	get_tree().paused=true;
	#If the pause time is at 0 set it to the start pause time
	if current_pause == 0:
		current_pause=pause_time;
	else:
		#Start the timer used to resume the game and show the resume label
		resume_timer.start();
		resume.text = String(current_pause/2);
		resume.show();


func _on_ResumTimer_timeout():
	#When the timer of 0.5 seconde time out.
	
	#Reduce the current pause time by 1, if it's a entire second set the text label if it's not, play the animation
	current_pause-=1;
	if current_pause%2==0:
		resume.text = String(current_pause/2);
	else:
		resume_animation.play("nextSecond");
		
	#When the unpause cooldown is done, resume the game
	if current_pause == 0:
		get_tree().paused=false;
		resume_timer.stop();
		resume.hide();


func _on_AnimationPlayer_animation_finished(anim_name):
	#Resize the label when the animation is ended
	resume.rect_scale=Vector2(1,1);
