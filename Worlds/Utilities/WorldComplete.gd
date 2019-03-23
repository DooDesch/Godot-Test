extends Area2D

export(String, FILE, "*.tscn") var next_world


func _physics_process(_delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			var _temp = get_tree().change_scene(next_world)