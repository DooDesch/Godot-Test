extends Area2D

signal attack_finished

onready var character = $"../.."

export(int) var damage = 20

var attack


func _ready():
	attack = false


func attack():
	_change_state(true)


func attack_finished():
	_change_state(false)
	emit_signal("attack_finished")


func _change_state(new_state):
	attack = new_state


func is_owner(body):
	return body == character


func _on_Attack_body_entered(body):
	if attack:
		if not body.is_in_group("character"):
			return
		if is_owner(body):
			return
		print("Try do Damage : ", damage)
		body.take_damage(damage)
