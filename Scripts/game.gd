extends Node2D

@onready var round_indicator: RichTextLabel = $RoundIndicator
@onready var player_class_label: RichTextLabel = $PlayerClass
@onready var enemy_class_label: RichTextLabel = $EnemyClass
@onready var player_hp_label: RichTextLabel = $PlayerHP
@onready var enemy_hp_label: RichTextLabel = $EnemyHP
@onready var info_message: RichTextLabel = $InfoMessage

const CLASSES = ["Warrior", "Healer", "Thief"]

var enemy_class = CLASSES[randi() % CLASSES.size()]
var game_round = 1
var enemy_hp = 20
var player_hp = 20
var enemy_blocked = false
var enemy_healed = false
var enemy_stolen = false

func _ready() -> void:
	round_indicator.append_text(str(game_round))
	player_class_label.append_text(Globals.player_class)
	enemy_class_label.append_text(enemy_class)
	player_hp_label.append_text(str(player_hp))
	enemy_hp_label.append_text(str(enemy_hp))

func _on_attack_button_pressed() -> void:
	var player_attack = randi_range(1, 20)
	var enemy_choice = randi_range(1, 2)
	
	if enemy_class == "Warrior" and enemy_blocked == false and enemy_choice == 1:
		var enemy_blocked_dmg = randi_range(1, 4)
		player_attack -= enemy_blocked_dmg
		info_message.clear()
		info_message.add_text("Enemy blocked")
	
	elif enemy_class == "Warrior" and enemy_blocked == false and enemy_choice == 2:
		info_message.clear()
		info_message.add_text("Enemy did not block")

#func enemy_counteraction(class):
	
