extends Node2D

@onready var meteor_spawn_location = $MeteorPath/MeteorSpawnLocation

var player_scene = preload("res://scenes/player.tscn")
var player: Player = null

var max_meteor_count = 10

var life = 3

var meteor_scenes: Array[PackedScene] = [
	preload("res://scenes/big_meteor_1.tscn"),
	preload("res://scenes/big_meteor_2.tscn"),
	preload("res://scenes/big_meteor_3.tscn"),
	preload("res://scenes/big_meteor_4.tscn"),
	preload("res://scenes/med_meteor_1.tscn"),
	preload("res://scenes/med_meteor_2.tscn"),
	preload("res://scenes/small_meteor_1.tscn"),
	preload("res://scenes/small_meteor_2.tscn"),
]


func _ready():
	spawn_player()


func spawn_player():
	var screen_size = get_viewport_rect().size

	player = player_scene.instantiate()
	add_child(player)
	player.global_position = screen_size / 2
	player.died.connect(_on_player_died)
	player.start_invincibility()


func _on_timer_timeout():
	# avoid creating too many meteors, or creating meteors when the player is dead
	if not player or get_tree().get_nodes_in_group("meteors").size() > max_meteor_count:
		return

	# instantiate a random meteor
	var i = randi() % meteor_scenes.size()
	var meteor = meteor_scenes[i].instantiate()
	add_child(meteor)

	# pick a random position along the meteor spawn path
	meteor_spawn_location.progress_ratio = randf()
	var meteor_position = meteor_spawn_location.global_position

	meteor.initialize(meteor_position, player)


func _on_player_died():
	print("remove")
	player.queue_free()
	player = null
	life -= 1

	if life:
		await get_tree().create_timer(1).timeout
		spawn_player()
	else:
		print("Game Over")

