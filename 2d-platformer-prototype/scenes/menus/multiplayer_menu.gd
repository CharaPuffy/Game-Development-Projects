extends Control

func _ready() -> void:
	$CenterContainer/VBox/TwoPlayerButton.pressed.connect(_on_two_player_pressed)
	$CenterContainer/VBox/BackButton.pressed.connect(_on_back_pressed)

func _on_two_player_pressed() -> void:
	GameState.is_multiplayer = true
	get_tree().change_scene_to_file("res://scenes/menus/level_select.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
