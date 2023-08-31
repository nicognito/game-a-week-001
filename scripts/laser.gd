class_name Laser
extends Area2D

@export var speed = 15

var direction = null


func _ready():
	direction = Vector2.from_angle(rotation - PI / 2).normalized()


func _process(delta):
	global_position += direction * speed * scale


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
