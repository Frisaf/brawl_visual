extends Node2D

@export var winner: RichTextLabel

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Globals.winner == "Player":
		winner.text = "Player won"
	
	elif Globals.winner == "Enemy":
		winner.text = "Enemy won"

func _on_play_again_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/character_choice.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
