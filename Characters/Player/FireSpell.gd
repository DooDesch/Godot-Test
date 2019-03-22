extends Particles2D

onready var player = get_node("../..")


func _ready():
	visible = true
	emitting = false


func _cast_loop():
	emitting = true


func _cast_end():
	emitting = false


func _process(_delta):
	if player.direction < 0:
		rotation_degrees = 180
	elif player.direction > 0:
		rotation_degrees = 0
	pass
