extends Node2D

@onready var warrior_info: RichTextLabel = $"Class Info/warrior_info"
@onready var healer_info: RichTextLabel = $"Class Info/healer_info"
@onready var thief_info: RichTextLabel = $"Class Info/thief_info"
@onready var start_button: Button = $start_button

var selected_class = ""
var player_class = ""

func _on_warrior_button_pressed() -> void:
	selected_class = "Warrior"
	warrior_info.visible = true
	healer_info.visible = false
	thief_info.visible = false
	start_button.visible = true

func _on_healer_button_pressed() -> void:
	selected_class = "Healer"
	warrior_info.visible = false
	healer_info.visible = true
	thief_info.visible = false
	start_button.visible = true

func _on_thief_button_pressed() -> void:
	selected_class = "Thief"
	warrior_info.visible = false
	healer_info.visible = false
	thief_info.visible = true
	start_button.visible = true
