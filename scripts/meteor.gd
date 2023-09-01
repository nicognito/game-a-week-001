class_name Meteor
extends Area2D

signal destroyed(position, size, direction)

enum MeteorSize {
	SMALL,
	MEDIUM,
	BIG,
}

var meteor_size = null

@onready var sprite = $Sprite2D

var buffer = 20
var speed = 100
var direction = Vector2.ZERO

func _ready():
	body_entered.connect(_on_body_entered)


func _process(delta):
	global_position += delta * direction * speed

	var buffer = sprite.get_rect().size
	var buffer_width = buffer.x
	var buffer_height = buffer.y

	var screen_size = get_viewport_rect().size
	if global_position.x < 0 - buffer_width / 2:
		global_position.x = screen_size.x - 1 + buffer_width / 2
	elif global_position.x > screen_size.x - 1 + buffer_width / 2:
		global_position.x = 0 - buffer_width / 2
	if global_position.y < 0 - buffer_height / 2:
		global_position.y = screen_size.y - 1 + buffer_height / 2
	elif global_position.y > screen_size.y - 1 + buffer_height / 2:
		global_position.y = 0 - buffer_height / 2


func initialize(new_position, towards_position):
	rotation = 0
	global_position = new_position

	# move towards the player with jitter
	var angle = get_angle_to(towards_position)
	var jitter = randf_range(-PI / 4, PI / 4)
	direction = Vector2.from_angle(angle + jitter).normalized()

	# random rotation
	rotation = TAU * randf()


func _on_body_entered(body):
	if body is Player:
		body.die()
		destroy()


func _on_area_entered(area):
	if area is Laser:
		area.queue_free()
		destroy()

func destroy():
	destroyed.emit(global_position, meteor_size, direction)
	queue_free()
