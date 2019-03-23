extends Light2D


export(bool) var light_on = true
export(float, 0, 1) var min_energy = .5

var normal_energy = energy
var set_energy = energy
var player


func _ready():
	enabled = light_on
	
	if $"../../Player":
		player = $"../../Player"


func _input(_event):
	if Input.is_action_just_pressed("light"):
		light_on = !light_on


func _process(_delta):
	if player.anim == "crouch":
		set_energy = min_energy
	else:
		set_energy = normal_energy
	
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