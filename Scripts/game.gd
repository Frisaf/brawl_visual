extends Node2D

@onready var round_indicator: RichTextLabel = $RoundIndicator
@onready var player_class_label: RichTextLabel = $PlayerClass
@onready var enemy_class_label: RichTextLabel = $EnemyClass

const CLASSES = ["Warrior", "Healer", "Thief"]

var enemy_class = CLASSES[randi() % CLASSES.size()]
var game_round = 1
var enemy_hp = 20
var player_hp = 20
var player_class

func _ready() -> void:
	round_indicator.append_text(str(game_round))
	player_class_label.append_text(Globals.player_class)
	enemy_class_label.append_text(enemy_class)
