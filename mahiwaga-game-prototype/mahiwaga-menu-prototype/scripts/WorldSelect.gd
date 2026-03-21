extends Control

# WorldSelect.gd
# Shows three available worlds. Selecting one loads the LevelSelect scene
# with that world's data passed through GameState.

const WORLD_NAMES := ["VERDANT FOREST", "ASHEN DESERT", "SHADOWKEEP"]


func _ready() -> void:
	$BackButton.pressed.connect(_on_back_pressed)

	for i in range(3):
		var btn: Button = _get_enter_button(i)
		btn.pressed.connect(_on_world_selected.bind(i))


func _get_enter_button(index: int) -> Button:
	return $WorldContainer.get_child(index).get_child(0).get_node("EnterBtn%d" % index)


func _on_world_selected(index: int) -> void:
	if Engine.has_singleton("GameState"):
		Engine.get_singleton("GameState").selected_world = index
	# Pass world index via GameState, then open LevelSelect.
	SceneTransition.fade_to("res://scenes/LevelSelect.tscn")


func _on_back_pressed() -> void:
	SceneTransition.fade_to("res://scenes/PlayMenu.tscn")
