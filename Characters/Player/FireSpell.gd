extends Node2D

onready var particles = get_node("Particles2D")
onready var player = get_node("../..")

func _ready():
	visible = true
	particles.emitting = false
	
func _cast_loop():
	particles.emitting = true
	
func _cast_end():
	particles.emitting = false

func _process(_delta):
	if player.direction < 0:
		rotation = 180
	elif player.direction > 0:
		rotation = 0
	pass
