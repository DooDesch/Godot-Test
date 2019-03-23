extends "res://Characters/Character.gd"


export(int) var SPRINT = 150
export(int) var JUMP_HEIGHT = -550

onready var attackTimer : Timer = get_node("AttackTimer")
#onready var jumpTimer = get_node("JumpTimer")

var spell = false
var jump = false
var crouch = false


func _input(_event):
	direction = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	
	if Input.is_action_pressed("sprint"): sprint = SPRINT
	else: sprint = 0
	
	if Input.is_action_just_pressed("spell"): spell = !spell
	
	if Input.is_action_pressed("jump"): jump = true
	else: jump = false
	
	if Input.is_action_pressed("crouch"): crouch = true
	else: crouch = false
	
	if Input.is_action_just_pressed("attack") and attackTimer.is_stopped():
		if !attackArray["attack1"]:
			attackArray["attack1"] = true
		elif !attackArray["attack2"]:
			attackArray["attack2"] = true
		elif !attackArray["attack3"]:
			attackArray["attack3"] = true
		
		comboTimer.stop()
		comboTimer.start()
		attackTimer.start()


func attack_loop():
	.attack_loop()
	
	if is_on_floor:
		if spell:
			direction = 0 #Prevent changing looking direction
			is_frozen = true #Prevent moving vertical or horizontal


func animation_loop():
	.animation_loop()
	
	if is_on_floor:
		if spell:
			anim = "castloop"
		elif jump:
			anim = "jump"
		elif crouch and !attackArray["attack1"]:
			anim = "crouch"
	elif !attackArray["attack1"]:
		if velocity.y < 0:
			if jump:
				anim = "jump"
		else:
			anim = "fall"


func move_loop():
	.move_loop()
	
	if is_on_floor:
		if jump: #If jump-key is pressed
			velocity.y = JUMP_HEIGHT #Jump
		if crouch: #If crouch-key is pressed
			can_move = false
	else:
		if velocity.y < 0 and jump: #If character is going up and jump-key is pressed
			velocity.y -= GRAVITY/2.0 #Reduce Gravity to jump higher


func _on_JumpTimer_timeout():
	pass # Replace with function body.
