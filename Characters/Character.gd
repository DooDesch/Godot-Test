extends KinematicBody2D


signal _on_character_health_changed
signal _on_character_died

onready var animTree : AnimationTree = get_node("Sprite/AnimationTree")
onready var animPlayer : AnimationPlayer = get_node("Sprite/AnimationPlayer")
onready var collision : CollisionShape2D = get_node("CollisionShape2D")
onready var comboTimer : Timer = get_node("ComboTimer")

export(int) var MAX_HEALTH = 100
export(int) var GRAVITY = 20
export(int) var ACCELERATION = 50
export(int) var MAX_SPEED = 300

const UP = Vector2(0, -1)

var velocity = Vector2()
var direction = 0
var sprint = 0
var anim = "idle"
var can_move = true
var can_fall = true
var is_frozen = false
var attackArray = {'attack1': false, 'attack2': false, 'attack3': false}
var dead = false
var hurt = false
var health
var is_on_floor = is_on_floor()


func _ready():
	is_on_floor = is_on_floor()
	
	if !health:
		 health = MAX_HEALTH


func _physics_process(_delta):
	reset_vars()
	
	dead = check_health()
	
	move_loop()
	
	attack_loop()
	
	animation_loop()
	
	move()
	
	animTree.play(anim)
	
	if dead: die()


func reset_vars():
	is_on_floor = is_on_floor()
	can_move = true
	can_fall = true
	is_frozen = false


func check_health():
	if health <= 0:
		return true
	return false


func move_loop():
	velocity.y += GRAVITY
	
	if direction > 0: #Move right
		velocity.x = min(velocity.x + ACCELERATION + sprint, MAX_SPEED + sprint)
	elif direction < 0: #Move left
		velocity.x = max(velocity.x - ACCELERATION - sprint, -MAX_SPEED - sprint)
	else: #Stop moving
		velocity.x = lerp(velocity.x, 0, 0.4)


func attack_loop():
	if attackArray["attack3"]:
		can_move = false
		if !comboTimer.is_stopped():
			comboTimer.stop()
	elif is_on_floor:
		if attackArray["attack2"]:
			can_move = false
		elif attackArray["attack1"]:
			can_move = false
	else:
		if attackArray["attack2"]:
			velocity.y -= GRAVITY/5.0
		elif attackArray["attack1"]:
			velocity.y -= GRAVITY/5.0


func animation_loop():
	if dead:
		anim = "die"
		return
	
	if hurt:
		hurt = false
		animPlayer.play("hurt")
	
	if is_on_floor:
		if attackArray["attack3"]:
			anim = "attack3"
		elif attackArray["attack2"]:
			anim = "attack2"
		elif attackArray["attack1"]:
			anim = "attack1"
		elif velocity.x < 5 and velocity.x > -5:
			anim = "idle"
		elif velocity.x != 0:
			anim = "run"
	else:
		if attackArray["attack3"]:
			anim = "airattack3loop"
		elif attackArray["attack2"]:
			anim = "airattack2"
		elif attackArray["attack1"]:
			anim = "airattack1"


func move():
	if !can_move:
		velocity.x = 0
	if !can_fall:
		velocity.y = 0
	if !is_frozen and !dead:
		velocity = move_and_slide(velocity, UP)


func die():
	collision.disabled = true
	modulate.a -= 0.01


func take_damage(damage):
	#print("Damage : ", damage)
	if dead:
		return
	
	health -= damage
	hurt = true
	#print("Health : ", health)
	if health <= 0:
		health = 0
		emit_signal("_on_character_died")
		return
	
	emit_signal("_on_character_health_changed")


func reset_attack_combo():
	attackArray["attack1"] = false
	attackArray["attack2"] = false
	attackArray["attack3"] = false


func _on_attack3_end():
	reset_attack_combo()
	comboTimer.stop()


func _on_ComboTimer_timeout():
	reset_attack_combo()


func _on_AttackTimer_timeout():
	pass # Replace with function body.