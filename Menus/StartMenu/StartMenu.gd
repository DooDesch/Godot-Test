extends Control

var temp


func _on_Start_pressed():
	temp = get_tree().change_scene("res://Worlds/World.tscn")


func _on_Quit_pressed():
	temp = get_tree().quit()
