extends ParallaxBackground

@export var scroll_speed = 10

@onready var sprite = $ParallaxLayer/Sprite2D

func _process(delta):
	sprite.region_rect.position += delta * Vector2(scroll_speed, scroll_speed)
