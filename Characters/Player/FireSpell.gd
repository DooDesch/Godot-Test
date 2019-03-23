extends Particles2D


onready var sprite = get_node("..")
onready var positions = {'right': -position.x, 'left': position.x}


func _ready():
	visible = true
	emitting = false


func _cast_loop():
	emitting = true


func _cast_end():
	emitting = false


func _process(_delta):
	if sprite.flip_h == true:
		process_material.gravity = Vector3(-1000, 0, 0)
		position.x = positions['right']
	elif sprite.flip_h == false:
		process_material.gravity = Vector3(1000, 0, 0)
		position.x = positions['left']
