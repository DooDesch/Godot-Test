extends "res://Characters/Character.gd"


export(Vector2) var max_distance = Vector2(50, 50)

onready var debugTimer : Timer = get_node("DebugTimer")

var parent
var parent_sprite
var following : Dictionary = {'x': false, 'y': false}
var send_pixie = false


func _ready():
	if $"../Player":
		parent = $"../Player"
		parent_sprite = $"../Player/Sprite"


func _input(_event):
	if Input.is_action_pressed("send_pixie"): send_pixie = true
	else: send_pixie = false


func move_loop():
	if send_pixie:
		if parent_sprite.flip_h:
			velocity.x = max(velocity.x - ACCELERATION, -MAX_SPEED*1.5)
			direction = -1
		elif !parent_sprite.flip_h:
			velocity.x = min(velocity.x + ACCELERATION, MAX_SPEED*1.5)
			direction = 1
		return
	
	if (following.x and velocity.x == 0 or following.y and velocity.y == 0) and debugTimer.is_stopped():
		print("----------------")
		print("DEBUG X : ", following.x, velocity.x)
		print("DEBUG Y : ", following.y, velocity.y)
		debugTimer.start()
	elif !following.x and !following.y and !debugTimer.is_stopped():
		debugTimer.stop()
	
	following.x = false
	following.y = false
	
	if parent.position.x > position.x + max_distance.x:
		following.x = true
		velocity.x = min(velocity.x + ACCELERATION, MAX_SPEED)
		direction = 1
	elif parent.position.x < position.x - max_distance.x:
		following.x = true
		velocity.x = max(velocity.x - ACCELERATION, -MAX_SPEED)
		direction = -1
	else: #Stop moving
		velocity.x = lerp(velocity.x, 0, 0.4)
		direction = 0
	
	if parent.position.y - max_distance.y > position.y + 20:
		following.y = true
		velocity.y = min(velocity.y + ACCELERATION, MAX_SPEED)
	elif parent.position.y - max_distance.y < position.y - 20:
		following.y = true
		velocity.y = max(velocity.y - ACCELERATION, -MAX_SPEED)
	else:
		velocity.y = lerp(velocity.y, 0, 0.4)


func animation_loop():
	anim = "idle"


func _on_DebugTimer_timeout():
	position = parent.position
