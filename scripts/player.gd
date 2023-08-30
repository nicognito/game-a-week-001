extends CharacterBody2D


@export var acceleration = 5
@export var turn_speed = 250
@export var braking_factor = 100
@export var max_speed = 200


func _process(delta):
	if Input.is_action_pressed("turn_left"):
		rotation_degrees -= turn_speed * delta
	if Input.is_action_pressed("turn_right"):
		rotation_degrees += turn_speed * delta


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
		global_position.x = screen_size.x
	elif global_position.x > screen_size.x - 1:
		global_position.x = 0
	if global_position.y < 0:
		global_position.y = screen_size.y
	elif global_position.y > screen_size.y - 1:
		global_position.y = 0
