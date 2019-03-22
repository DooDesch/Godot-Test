extends Sprite

onready var player = get_node("..")

func _process(_delta):
	if player.direction < 0:
		set_flip_h(true)
	elif player.direction > 0:
		set_flip_h(false)
