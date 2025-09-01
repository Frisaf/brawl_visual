extends Node2D

@onready var round_indicator: RichTextLabel = $RoundIndicator
@onready var player_class_label: RichTextLabel = $PlayerClass
@onready var enemy_class_label: RichTextLabel = $EnemyClass

const CLASSES = ["Warrior", "Healer", "Thief"]

var enemy_class = CLASSES[randi() % CLASSES.size()]
var round = 1
var enemy_hp = 20

func _ready() -> void:
	round_indicator.append_text(str(round))
	player_class_label.append_text(CharacterChoice.player_class)
	enemy_class_label.append_text(enemy_class)
