extends Control

func _ready() -> void:
	$CenterContainer/VBox/Level1Button.pressed.connect(_on_level1_pressed)
	$CenterContainer/VBox/Level2Button.pressed.connect(_on_level2_pressed)
	$CenterContainer/VBox/BackButton.pressed.connect(_on_back_pressed)
	_refresh_lock_state()

func _refresh_lock_state() -> void:
	var level2_unlocked = GameState.is_level_unlocked(2)
	var btn = $CenterContainer/VBox/Level2Button
	btn.disabled = not level2_unlocked
	if level2_unlocked:
		btn.text = "LEVEL 2"
		btn.modulate = Color(1, 1, 1, 1)
	else:
		btn.text = "LEVEL 2  [LOCKED]"
		btn.modulate = Color(1, 1, 1, 0.45)

func _on_level1_pressed() -> void:
	GameState.start_level = 1
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_level2_pressed() -> void:
	GameState.start_level = 2
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_back_pressed() -> void:
	if GameState.is_multiplayer:
		get_tree().change_scene_to_file("res://scenes/menus/multiplayer_menu.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
