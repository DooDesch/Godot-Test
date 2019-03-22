extends Light2D

onready var jumpTimer = get_node("JumpTimer")

var normal_energy = energy
var set_energy = energy
var min_energy = .5
var light_on = true
var jumptimer = false

func _input(_event):
	if Input.is_action_just_pressed("light"):
		light_on = !light_on
	
	if Input.is_action_pressed("crouch") and !jumptimer:
		set_energy = min_energy
	else:
		set_energy = normal_energy
		
	if Input.is_action_pressed("jump"):
		jumptimer = true
		jumpTimer.stop()
		jumpTimer.start()
		set_energy = normal_energy
	pass
	
func _process(_delta):
	#enabled = light_on
	
	if light_on:
		if energy > normal_energy:
			energy = 1
			
		if energy > set_energy:
			energy -= 0.01
		else:
			energy += 0.02
	else:
		if energy > 0:
			energy -= 0.03
	pass

func _on_JumpTimer_timeout():
	jumptimer = false
	pass # Replace with function body.
