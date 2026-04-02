extends Control

# WorldSelect.gd
# Shows three worlds. World 0 (Philippines) is playable and leads to the
# main gameplay. Worlds 1 and 2 are locked until future completion conditions
# are met (reserved for later implementation).

# World unlock conditions — reserved for future use.
# World 0 (Philippines) is always unlocked.
# World 1 and 2 unlock conditions TBD.
const WORLD_UNLOCKED := [true, false, false]

# Fade duration in seconds for entering Philippines.
const PHILIPPINES_FADE_DURATION := 1.5


func _ready() -> void:
	$BackButton.pressed.connect(_on_back_pressed)

	for i in range(3):
		var btn: Button = _get_enter_button(i)
		if WORLD_UNLOCKED[i]:
			btn.pressed.connect(_on_world_selected.bind(i))
		else:
			# Disable locked world buttons.
			btn.disabled = true


func _get_enter_button(index: int) -> Button:
	return $WorldContainer.get_child(index).get_child(0).get_node("EnterBtn%d" % index)


func _on_world_selected(index: int) -> void:
	if index == 0:
		# Philippines → enter main gameplay with 1.5s fade.
		GameState.selected_world = index
		SceneTransition.fade_to("res://Scenes/guild_hall.tscn", PHILIPPINES_FADE_DURATION)
	else:
		# Future worlds: reserved.
		GameState.selected_world = index
		SceneTransition.fade_to("res://scenes/LevelSelect.tscn")


func _on_back_pressed() -> void:
	SceneTransition.fade_to("res://scenes/PlayMenu.tscn")
