extends Control

func _ready() -> void:
	$CenterContainer/VBox/StartButton.pressed.connect(_on_start_pressed)
	$CenterContainer/VBox/MultiplayerButton.pressed.connect(_on_multiplayer_pressed)
	$CenterContainer/VBox/QuitButton.pressed.connect(_on_quit_pressed)

func _on_start_pressed() -> void:
	GameState.is_multiplayer = false
	get_tree().change_scene_to_file("res://scenes/menus/level_select.tscn")

func _on_multiplayer_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/multiplayer_menu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
