extends "res://Characters/Character.gd"


onready var dirTimer : Timer = get_node("SimpleAI/Dir")


func _ready():
	direction = 0
	dirTimer.start()


func _process(_delta):
	if dead and !dirTimer.is_stopped():
		dirTimer.stop()
	if direction != 0 and velocity == Vector2(0, 0):
		_on_Dir_timeout() 


func _on_Dir_timeout():
	direction = random_int(-1, 2)
	dirTimer.start()


func random_int(min_value, max_value, inclusive_range = false):
	if inclusive_range:
		max_value += 1
	var range_size = max_value - min_value
	return (randi() % range_size) + min_value


func take_damage(damage):
	.take_damage(damage)
	
	if !attackArray["attack3"]:
		attackArray["attack3"] = true
	comboTimer.start()