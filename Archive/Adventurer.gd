extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 20
const ACCELERATION = 50
const MAX_SPEED = 300
const JUMP_HEIGHT = -550
const SPRINT = 150

onready var animtree = get_node("Sprite/AnimationTree")
onready var attackTimer = get_node("AttackTimer")
onready var comboTimer = get_node("ComboTimer")
onready var jumpTimer = get_node("JumpTimer")
#onready var fireSpell = get_node("Sprite/FireSpell")

var motion = Vector2()
var input = 0
var sprint = 0
var anim = "idle"
var jump = false
var spell = false
var can_move = true
var can_fall = true
var is_frozen = false
var attackArray = {'attack1': false, 'attack2': false, 'attack3': false}


func _input(_event):
	input = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	
	if Input.is_action_pressed("sprint"): sprint = SPRINT
	else: sprint = 0
	
	if Input.is_action_pressed("spell"): spell = !spell
	
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
	
	pass


func _physics_process(_delta):	
	can_move = true
	can_fall = true
	is_frozen = false
	
	move_loop()
	
	attack_loop()
	
	play_anim(anim)
	
	motion()
	
	pass


func play_anim(anim):
	if animtree.playback.get_current_node() != anim: # if we aren't already playing the same animation
		animtree.playback.travel(anim)
	else:  
		return


func attack_loop():
	if is_on_floor():
		if spell:
			is_frozen = true
			anim = "castloop"
		
		if attackArray["attack3"]:
			can_move = false
			anim = "attack3"
		elif attackArray["attack2"]:
			can_move = false
			anim = "attack2"
		elif attackArray["attack1"]:
			can_move = false
			anim = "attack1"
	else:
		if attackArray["attack3"]:
			can_move = false
			anim = "airattack3loop"
		elif attackArray["attack2"]:
			motion.y -= GRAVITY/5.0
			anim = "airattack2"
		elif attackArray["attack1"]:
			motion.y -= GRAVITY/5.0
			anim = "airattack1"
	pass


func move_loop():
	motion.y += GRAVITY
	var friction = false
	
	if input > 0:
		motion.x = min(motion.x + ACCELERATION + sprint, MAX_SPEED + sprint)
	elif input < 0:
		motion.x = max(motion.x - ACCELERATION - sprint, -MAX_SPEED - sprint)
	else:
		motion.x = lerp(motion.x, 0, 0.4)
	
	if is_on_floor():
		if motion.x < 5 and motion.x > -5:
			anim = "idle"
			friction = true
		elif motion.x != 0:
			anim = "run"
		
		if Input.is_action_pressed("jump"):
			jump = false
			jumpTimer.start()
			anim = "jump"
			motion.y = JUMP_HEIGHT
		if Input.is_action_pressed("crouch"):
			anim = "crouch"
			motion.x = 0
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.4)
		
	else:
			
		if motion.y < 0:
			if Input.is_action_pressed("jump"):
				motion.y -= GRAVITY/2.0
			
			anim = "jump"
		else :
			anim = "fall"
			
		if friction == true:
			motion.x = lerp(motion.x, 0, 0.05)
	
	pass


func motion():
	if !can_move:
		motion.x = 0
	if !can_fall:
		motion.y = 0
	if !is_frozen:
		motion = move_and_slide(motion, UP)
	pass


func reset_attack_combo():
	attackArray["attack1"] = false
	attackArray["attack2"] = false
	attackArray["attack3"] = false
	pass


func _on_ComboTimer_timeout():
	reset_attack_combo()
	pass # Replace with function body.


func _on_JumpTimer_timeout():
	pass # Replace with function body.


func _on_AttackTimer_timeout():
	pass # Replace with function body.

func _on_attack3_end():
	reset_attack_combo()
	comboTimer.stop()
	pass