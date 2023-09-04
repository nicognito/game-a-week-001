extends Node


func _on_main_title_button_pressed():
	get_tree().change_scene_to_file("res://scenes/start_screen.tscn")


func set_score(score):
	$ScoreLabel.text = "YOUR SCORE: " + str(score)
