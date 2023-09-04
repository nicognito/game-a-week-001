class_name Player
extends CharacterBody2D

signal died

@export var acceleration = 5
@export var turn_speed = 200
@export var braking_factor = 100
@export var max_speed = 200

var laser_scene = preload("res://scenes/laser.tscn")

var is_invincible = false

@onready var laser_container = $LaserContainer
@onready var laser_marker = $LaserMarker

func _process(delta):
	if is_invincible:
		modulate.a = 0.5 if Engine.get_frames_drawn() % 8 < 4 else 1.0
	else:
		modulate.a = 1

	if Input.is_action_pressed("turn_left"):
		rotation_degrees -= turn_speed * delta
	if Input.is_action_pressed("turn_right"):
		rotation_degrees += turn_speed * delta
	if Input.is_action_just_pressed("fire"):
		fire_laser()


func _physics_process(delta):
	var direction = Input.get_axis("move_forward", "move_back")
	if not direction:
		velocity -= velocity / braking_factor
	else:
		velocity += acceleration * Vector2(0, direction).rotated(rotation)

	# cap speed
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed

	move_and_slide()

	var screen_size = get_viewport_rect().size
	if global_position.x < 0:
		global_position.x = screen_size.x - 1
	elif global_position.x > screen_size.x - 1:
		global_position.x = 0
	if global_position.y < 0:
		global_position.y = screen_size.y - 1
	elif global_position.y > screen_size.y - 1:
		global_position.y = 0


func fire_laser():
	var laser: Laser = laser_scene.instantiate()
	laser.global_position = laser_marker.global_position
	laser.rotation = rotation
	laser_container.add_child(laser)
	AudioPlayer.play_sound("laser")


func die():
	AudioPlayer.play_sound("die")
	died.emit()


func start_invincibility():
	$MainBodyCollisionShape2D.disabled = true
	$WingsCollisionShape2D.disabled = true
	is_invincible = true
	await get_tree().create_timer(2).timeout
	is_invincible = false
	$MainBodyCollisionShape2D.disabled = false
	$WingsCollisionShape2D.disabled = false
