extends Node2D

@onready var round_indicator: RichTextLabel = $RoundIndicator
@onready var player_class_label: RichTextLabel = $PlayerClass
@onready var enemy_class_label: RichTextLabel = $EnemyClass
@onready var player_hp_label: RichTextLabel = $PlayerHP
@onready var enemy_hp_label: RichTextLabel = $EnemyHP
@onready var info_message: RichTextLabel = $InfoMessage
@onready var attack_info: RichTextLabel = $AttackInfo
@onready var choice_yes: Button = $HBoxContainer/ChoiceYes
@onready var choice_no: Button = $HBoxContainer/ChoiceNo

const CLASSES = ["Warrior", "Healer", "Thief"]

var enemy_class = CLASSES[randi() % CLASSES.size()]
var player_class = Globals.player_class
var game_round = 1
var enemy_hp = 20
var player_hp = 20
var enemy_blocked = false
var enemy_healed = false
var enemy_stolen = false
var player_blocked = false
var player_healed = false
var player_stolen = false
var yes = true

func _ready() -> void:
	round_indicator.append_text(str(game_round))
	player_class_label.append_text(player_class)
	enemy_class_label.append_text(enemy_class)
	player_hp_label.append_text(str(player_hp))
	enemy_hp_label.append_text(str(enemy_hp))

func player_action(choice):
	if player_class == "Warrior" and player_blocked == false and choice == 1:
		choice_yes.set_text("Block")
		choice_no.set_text("Don't block") # Something needs fixing here for it to work

func enemy_counteraction(choice):
	if enemy_class == "Warrior" and enemy_blocked == false and choice == 1:
		var enemy_blocked_dmg = randi_range(1, 4)
		info_message.clear()
		info_message.add_text("Enemy blocked " + str(enemy_blocked_dmg) + " of your attack")
		enemy_blocked = true
		return enemy_blocked_dmg
	
	elif enemy_class == "Warrior" and enemy_blocked == false and choice == 2:
		info_message.clear()
		info_message.add_text("Enemy did not block")
		return 0
	
	elif enemy_class == "Healer" and enemy_healed == false and choice == 1 and enemy_hp < 20:
		var enemy_healed_dmg = randi_range(1, 4)
		info_message.clear()
		info_message.add_text("Enemy healed " + str(enemy_healed_dmg) + " HP")
		enemy_healed = true
		return enemy_healed_dmg
	
	elif enemy_class == "Healer" and enemy_healed == false and choice == 2:
		info_message.clear()
		info_message.add_text("Enemy did not heal")
		return 0
	
	elif enemy_class == "Thief" and enemy_stolen == false and choice == 1:
		var enemy_stolen_dmg = randi_range(1, 4)
		info_message.clear()
		info_message.add_text("Enemy stole " + str(enemy_stolen_dmg) + " of your damage!")
		enemy_stolen = true
		return enemy_stolen_dmg
	
	elif enemy_class == "Thief" and enemy_stolen == false and choice == 2:
		info_message.clear()
		info_message.add_text("Enemy did not steal any damage")
		return 0
	
	else:
		info_message.clear()
		info_message.add_text("Enemy did not do anything...")
		return 0

func _on_attack_button_pressed() -> void: # Next round button
	var player_attack = randi_range(1, 20)
	var enemy_attack = randi_range(1, 20)
	var enemy_choice = randi_range(1, 2)
	
	game_round += 1
	
	round_indicator.clear()
	round_indicator.add_text("ROUND: %s" %[str(game_round)])
	
	# Enemy counteraction
	if enemy_class == "Warrior":
		var enemy_blocked_dmg = enemy_counteraction(enemy_choice)
		player_attack -= enemy_blocked_dmg
	
	elif enemy_class == "Healer":
		var enemy_healed_dmg = enemy_counteraction(enemy_choice)
		enemy_hp += enemy_healed_dmg
	
	elif enemy_class == "Thief":
		var enemy_stolen_dmg = enemy_counteraction(enemy_choice)
		enemy_attack += enemy_stolen_dmg
		player_attack -= enemy_stolen_dmg
	
	# Calculate final rolls
	if player_attack > enemy_attack:
		var damage = (player_attack - enemy_attack) / 2
		enemy_hp -= damage
		
		attack_info.clear()
		attack_info.add_text("Player dealt %s damage to the enemy" %[damage])
	
	elif player_attack < enemy_attack:
		var damage = (enemy_attack - player_attack) / 2
		player_hp -= damage
		
		attack_info.clear()
		attack_info.add_text("Enemy dealt %s damage to the player" %[damage])
	
	else:
		attack_info.clear()
		attack_info.add_text("It's a tie...")
	
	player_hp_label.clear()
	player_hp_label.add_text("Player HP: %s" %[player_hp])
	enemy_hp_label.clear()
	enemy_hp_label.add_text("Enemy HP: %s" %[enemy_hp])
	
	if player_hp <= 0:
		print("Enemy won")
	
	elif enemy_hp <= 0:
		print("Player won")
