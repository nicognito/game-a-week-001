extends Area2D


var buffer = 20
var speed = 100
var direction = Vector2.ZERO

func _ready():
	body_entered.connect(_on_body_entered)


func _process(delta):
	global_position += delta * direction * speed

	var screen_size = get_viewport_rect().size
	if global_position.x < 0 - buffer:
		global_position.x = screen_size.x - 1 + buffer
	elif global_position.x > screen_size.x - 1 + buffer:
		global_position.x = 0 - buffer
	if global_position.y < 0 - buffer:
		global_position.y = screen_size.y - 1 + buffer
	elif global_position.y > screen_size.y - 1 + buffer:
		global_position.y = 0 - buffer


func initialize(new_position, player):
	global_position = new_position

	# move towards the player with jitter
	var angle = get_angle_to(player.global_position)
	var jitter = randf_range(-PI / 8, PI / 8)
	direction = Vector2.from_angle(angle + jitter).normalized()

	# random rotation
	rotation = TAU * randf()


func _on_body_entered(body):
	if body is Player:
		body.die()
