extends "res://Characters/Character.gd"

const JUMP_HEIGHT = -550

var spell = false
var jump = false
var crouch = false


func _input(_event):
	direction = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	
	if Input.is_action_pressed("sprint"): sprint = SPRINT
	else: sprint = 0
	
	if Input.is_action_pressed("spell"): spell = !spell
	
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


func custom_attack():
	if is_on_floor:
		if spell:
			direction = 0 #Prevent changing looking direction
			is_frozen = true #Prevent moving vertical or horizontal


func custom_animation():
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


func custom_move():
	if is_on_floor:
		if jump:
			velocity.y = JUMP_HEIGHT
		if crouch:
			velocity.x = 0
	else:
		if velocity.y < 0:
			if jump:
				velocity.y -= GRAVITY/2.0


func _ready():
	health = MAX_HEALTH * 2
	pass
