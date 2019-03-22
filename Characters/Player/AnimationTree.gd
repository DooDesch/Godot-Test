extends AnimationTree

var playback : AnimationNodeStateMachinePlayback

# Called when the node enters the scene tree for the first time.
func _ready():
	playback = get("parameters/playback")
	playback.start("idle")
	active = true
	pass # Replace with function body.
