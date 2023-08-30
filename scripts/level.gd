extends Node2D

@onready var meteor_spawn_location = $MeteorPath/MeteorSpawnLocation
@onready var player = $Player

var max_meteor_count = 10

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

func _on_timer_timeout():
	# avoid creating too many meteors
	if get_tree().get_nodes_in_group("meteors").size() > max_meteor_count:
		return

	# instantiate a random meteor
	var i = randi() % meteor_scenes.size()
	var meteor = meteor_scenes[i].instantiate()
	add_child(meteor)

	# pick a random position along the meteor spawn path
	meteor_spawn_location.progress_ratio = randf()
	var meteor_position = meteor_spawn_location.global_position

	meteor.initialize(meteor_position, player)
