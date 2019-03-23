extends Area2D

signal attack_finished

onready var character : KinematicBody2D = $"../.."
onready var sprite : Sprite = $".."

export(int) var damage = 20

var attacking
var last_position = position.x


func _ready():
	attacking = false


func _process(_delta):
	if sprite.flip_h == true:
		if position.x != last_position:
			position.x = -position.x
			last_position = position.x


func attack():
	_change_state(true)


func attack_finished():
	_change_state(false)
	emit_signal("attack_finished")


func _change_state(state):
	attacking = state


func is_owner(body):
	return body == character


func _on_Attack_body_entered(body):
	if attacking:
		if not body.is_in_group("character"):
			return
		if is_owner(body):
			return
		#print("Try do Damage : ", damage)
		body.take_damage(damage)
