extends Node2D

@export var round_indicator: RichTextLabel
@export var choice_yes: Button
@export var choice_no: Button
@export var next_round_button: Button
@export var damage_info: RichTextLabel
@export var player_class_label: RichTextLabel
@export var enemy_class_label: RichTextLabel
@export var player_hp_label: RichTextLabel
@export var enemy_hp_label: RichTextLabel
@export var info_message: RichTextLabel
@export var attack_info: RichTextLabel
@export var game_over: Node2D
@export var player: Sprite2D

const CLASSES = ["Warrior", "Healer", "Thief"]

var enemy_class = CLASSES[randi() % CLASSES.size()]
var player_class = Globals.player_class
var game_round = 0
var enemy_hp = 20
var player_hp = player."player_hp"
var enemy_blocked = false
var enemy_healed = false
var enemy_stolen = false
var player_blocked = false
var player_healed = false
var player_stolen = false
var action_value = 0
var player_choice = ""
var no_button_pressed = false

func _ready() -> void:
	round_indicator.text = "Click the start button to start!"
	player_class_label.append_text(player_class)
	enemy_class_label.append_text(enemy_class)
	player_hp_label.append_text(str(player_hp))
	enemy_hp_label.append_text(str(enemy_hp))
	next_round_button.text = "START"
	choice_yes.disabled = true
	choice_no.disabled = true
	
	if player_class == "Warrior":
		choice_yes.text = "Block"
		choice_no.text = "Don't block"
	
	elif player_class == "Healer":
		choice_yes.text = "Heal"
		choice_no.text = "Don't heal"
	
	elif player_class == "Thief":
		choice_yes.text = "Steal"
		choice_no.text = "Don't steal"

# If it returns false, the yes/no buttons will be enabled. Else, they'll be disabled.
# true = action done, false = no action done
func check_action():
	if no_button_pressed == true:
		return true
		
	if player_blocked == true or player_healed == true or player_stolen == true:
		return true
	
	else:
		if player_hp >= 20 and player_class == "Healer":
			return true
			
		return false

func _on_choice_yes_pressed() -> void:
	action_value = randi_range(1, 4)
	player_choice = 1
	
	if player_class == "Warrior":
		info_message.clear()
		info_message.add_text("You will block " + str(action_value) + " of the enemy's attack next round.")
	
	elif player_class == "Healer":
		player_hp += action_value
		info_message.clear()
		info_message.add_text("You healed " + str(action_value) + " HP")
		player_hp_label.clear()
		player_hp_label.add_text("Player HP: %s" %[player_hp])
		player_healed = true
	
	elif player_class == "Thief":
		info_message.clear()
		info_message.add_text("You will steal " + str(action_value) + " from enemy's damage next round.")
	
	next_round_button.disabled = false

func enemy_counteraction(choice):
	var enemy_action_value = randi_range(1, 4)
	
	if enemy_class == "Warrior" and enemy_blocked == false and choice == 1:
		info_message.clear()
		info_message.add_text("Enemy blocked " + str(enemy_action_value) + " of your attack")
		enemy_blocked = true
	
	elif enemy_class == "Warrior" and enemy_blocked == false and choice == 2:
		info_message.clear()
		info_message.add_text("Enemy did not block")
		return 0
	
	elif enemy_class == "Healer" and enemy_healed == false and choice == 1 and enemy_hp < 20:
		info_message.clear()
		info_message.add_text("Enemy healed " + str(enemy_action_value) + " HP")
		enemy_hp_label.clear()
		enemy_hp_label.add_text("Enemy HP: %s" %[enemy_hp])
		enemy_healed = true
	
	elif enemy_class == "Healer" and enemy_healed == false and choice == 2:
		info_message.clear()
		info_message.add_text("Enemy did not heal")
		return 0
	
	elif enemy_class == "Thief" and enemy_stolen == false and choice == 1:
		info_message.clear()
		info_message.add_text("Enemy stole " + str(enemy_action_value) + " of your damage!")
		enemy_stolen = true
	
	elif enemy_class == "Thief" and enemy_stolen == false and choice == 2:
		info_message.clear()
		info_message.add_text("Enemy did not steal any damage")
		return 0
	
	else:
		info_message.clear()
		info_message.add_text("Enemy did not do anything...")
		return 0
	
	return enemy_action_value

func _on_attack_button_pressed() -> void: # Next round button
	var player_attack = randi_range(1, 20)
	var enemy_attack = randi_range(1, 20)
	var enemy_choice = randi_range(1, 2)
	
	next_round_button.text = "NEXT ROUND"
	
	game_round += 1
	
	round_indicator.clear()
	round_indicator.add_text("ROUND: %s" %[str(game_round)])
	
	if check_action() == false:
		choice_yes.disabled = false
		choice_no.disabled = false
		next_round_button.disabled = true
		
		if player_class == "Warrior":
			enemy_attack -= action_value
			player_blocked = true
		
		elif player_class == "Thief":
			enemy_attack -= action_value
			player_attack += action_value
			player_stolen = true
	
	elif no_button_pressed == true:
		choice_yes.disabled = false
		choice_no.disabled = false
		next_round_button.disabled = true
		no_button_pressed = false
	
	else:
		choice_yes.disabled = true
		choice_no.disabled = true
		next_round_button.disabled = false
	
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
	
	damage_info.clear()
	damage_info.add_text("Player attacked with %s\n" %[player_attack])
	damage_info.add_text("Enemy attacked with %s" %[enemy_attack])
	player_hp_label.clear()
	player_hp_label.add_text("Player HP: %s" %[player_hp])
	enemy_hp_label.clear()
	enemy_hp_label.add_text("Enemy HP: %s" %[enemy_hp])
	
	if player_hp <= 0:
		game_over.visible = true
		next_round_button.disabled = true
		Globals.winner = "Enemy"
	
	elif enemy_hp <= 0:
		game_over.visible = true
		next_round_button.disabled = true
		Globals.winner = "Player"

func _on_choice_no_pressed() -> void:
	choice_yes.disabled = true
	choice_no.disabled = true
	next_round_button.disabled = false
	info_message.clear()
	info_message.add_text("Player did not do anything.")
	no_button_pressed = true

func _process(delta: float) -> void:
	if choice_yes.disabled == true:
		choice_yes.mouse_default_cursor_shape = Control.CURSOR_ARROW
	
	else:
		choice_yes.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	
	if choice_no.disabled == true:
		choice_no.mouse_default_cursor_shape = Control.CURSOR_ARROW
	
	else:
		choice_no.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	
	if next_round_button.disabled == true:
		next_round_button.mouse_default_cursor_shape = Control.CURSOR_ARROW
	
	else:
		next_round_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
