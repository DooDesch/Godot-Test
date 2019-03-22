extends Control

var temp

func _ready():
	pass # Replace with function body.



func _on_Start_pressed():
	temp = get_tree().change_scene("res://World.tscn")
	pass # Replace with function body.


func _on_Quit_pressed():
	temp = get_tree().quit()
	pass # Replace with function body.
