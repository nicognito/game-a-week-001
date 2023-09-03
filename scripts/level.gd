extends Node2D

@onready var meteor_spawn_location = $MeteorPath/MeteorSpawnLocation
@onready var meteor_container = $MeteorContainer

var player_scene = preload("res://scenes/player.tscn")
var player: Player = null

var max_meteor_count = 10

var life = 3

var meteor_explosion_scene = preload("res://scenes/meteor_explosion.tscn")
var player_explosion_scene = preload("res://scenes/player_explosion.tscn")

var med_meteor_scenes = [
	preload("res://scenes/med_meteor_1.tscn"),
	preload("res://scenes/med_meteor_2.tscn"),
]

var small_meteor_scenes = [
	preload("res://scenes/small_meteor_1.tscn"),
	preload("res://scenes/small_meteor_2.tscn"),
]

var meteor_scenes: Array[PackedScene] = [
	preload("res://scenes/big_meteor_1.tscn"),
	preload("res://scenes/big_meteor_2.tscn"),
	preload("res://scenes/big_meteor_3.tscn"),
	preload("res://scenes/big_meteor_4.tscn"),
	med_meteor_scenes[0],
	med_meteor_scenes[1],
	small_meteor_scenes[0],
	small_meteor_scenes[1],
]


func _ready():
	spawn_player()


func spawn_player():
	var screen_size = get_viewport_rect().size

	player = player_scene.instantiate()
	add_child(player)
	player.global_position = screen_size / 2
	player.died.connect(_on_player_died)


func _on_timer_timeout():
	# avoid creating too many meteors, or creating meteors when the player is dead
	if not player or get_tree().get_nodes_in_group("meteors").size() >= max_meteor_count:
		return

	# instantiate a random meteor along the meteor spawn path
	meteor_spawn_location.progress_ratio = randf()
	var meteor_position = meteor_spawn_location.global_position
	spawn_meteor(meteor_scenes, meteor_position, player.global_position)


func _on_player_died():
	if not player:
		return

	var player_explosion = player_explosion_scene.instantiate()
	player_explosion.global_position = player.global_position
	add_child(player_explosion)

	player.queue_free()
	player = null
	life -= 1

	if life:
		await get_tree().create_timer(1).timeout
		spawn_player()
		player.start_invincibility()
	else:
		print("Game Over")


func _on_meteor_destroyed(meteor_position, meteor_size, meteor_direction):
	var meteor_explosion = meteor_explosion_scene.instantiate()
	meteor_container.add_child(meteor_explosion)
	meteor_explosion.emitting = true
	meteor_explosion.global_position = meteor_position

	if meteor_size == Meteor.MeteorSize.SMALL:
		return

	var scenes

	if meteor_size == Meteor.MeteorSize.BIG:
		scenes = med_meteor_scenes
	elif meteor_size == Meteor.MeteorSize.MEDIUM:
		scenes = small_meteor_scenes

	# split meteor in 2 smaller one
	for iteration in 2:
		spawn_meteor(scenes, meteor_position, meteor_position + meteor_direction)


func spawn_meteor(scenes, from, to):
	var i = randi() % scenes.size()
	var meteor = scenes[i].instantiate()
	meteor_container.add_child(meteor)
	meteor.destroyed.connect(_on_meteor_destroyed)
	meteor.initialize(from, to)
