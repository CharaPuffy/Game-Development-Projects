extends Control

# MainMenu.gd
# Handles the main menu with Play, Settings, and Quit buttons.

func _ready() -> void:
	$CenterContainer/VBoxContainer/PlayButton.pressed.connect(_on_play_pressed)
	$CenterContainer/VBoxContainer/SettingsButton.pressed.connect(_on_settings_pressed)
	$CenterContainer/VBoxContainer/QuitButton.pressed.connect(_on_quit_pressed)


func _on_play_pressed() -> void:
	SceneTransition.fade_to("res://scenes/PlayMenu.tscn")


func _on_settings_pressed() -> void:
	SceneTransition.fade_to("res://scenes/SettingsMenu.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
