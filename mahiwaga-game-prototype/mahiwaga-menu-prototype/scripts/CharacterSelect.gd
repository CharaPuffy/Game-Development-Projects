extends Control

# CharacterSelect.gd
# Displays four selectable characters. Choosing one shows a Confirm button.
# The confirmed selection is stored in GameState (autoload) for use in gameplay.

const CHARACTER_NAMES := ["WARRIOR", "RANGER", "MAGE", "ROGUE"]

var selected_index: int = -1


func _ready() -> void:
	$BackButton.pressed.connect(_on_back_pressed)
	$ConfirmPanel/ConfirmVBox/ConfirmButton.pressed.connect(_on_confirm_pressed)

	for i in range(4):
		var btn: Button = _get_select_button(i)
		btn.pressed.connect(_on_character_selected.bind(i))


func _get_select_button(index: int) -> Button:
	return $CharacterGrid.get_child(index).get_child(0).get_node("SelectBtn%d" % index)


func _on_character_selected(index: int) -> void:
	selected_index = index
	var confirm_label: Label = $ConfirmPanel/ConfirmVBox/ConfirmLabel
	confirm_label.text = "Selected: %s" % CHARACTER_NAMES[index]
	$ConfirmPanel.visible = true

	# Highlight selected card, dim others.
	for i in range(4):
		var card: PanelContainer = $CharacterGrid.get_child(i)
		card.modulate = Color(1.0, 1.0, 1.0, 1.0) if i == index else Color(0.5, 0.5, 0.5, 1.0)


func _on_confirm_pressed() -> void:
	if selected_index < 0:
		return
	# Save to GameState autoload (add GameState.gd as autoload in Project Settings).
	if Engine.has_singleton("GameState"):
		Engine.get_singleton("GameState").selected_character = selected_index
	# Navigate to world select after confirming character.
	SceneTransition.fade_to("res://scenes/WorldSelect.tscn")


func _on_back_pressed() -> void:
	SceneTransition.fade_to("res://scenes/PlayMenu.tscn")
