extends AnimationTree

var playback : AnimationNodeStateMachinePlayback

# Called when the node enters the scene tree for the first time.
func _ready():
	playback = get("parameters/playback")
	playback.start("idle")
	active = true
	pass # Replace with function body.


func play(animation):
	if playback.get_current_node() != animation: # if we aren't already playing the same animation
		playback.travel(animation)
	else:  
		return
