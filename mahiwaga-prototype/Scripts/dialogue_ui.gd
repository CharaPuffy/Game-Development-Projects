extends CanvasLayer
signal dialogue_finished

@onready var name_label = $DialogueControl/MarginContainer/Panel/ContentMargin/HBox/VBox/NameLabel
@onready var text_label = $DialogueControl/MarginContainer/Panel/ContentMargin/HBox/VBox/TextLabel
@onready var choice_container = $DialogueControl/MarginContainer/Panel/ContentMargin/HBox/VBox/ChoiceContainer
@onready var portrait = $DialogueControl/MarginContainer/Panel/ContentMargin/HBox/Portrait
@onready var next_button = $DialogueControl/MarginContainer/Panel/ContentMargin/HBox/NextButton

var dialogue_list: Array = []
var current_line_index: int = 0
var current_speaker: String = ""

func _ready():
	self.visible = false
	choice_container.visible = false
	next_button.pressed.connect(_on_next_button_pressed)
	choice_container.get_node("AcceptButton").pressed.connect(_on_accept_button_pressed)
	choice_container.get_node("RejectButton").pressed.connect(_on_reject_button_pressed)

func start_conversation(speakerName: String, lines: Array, _image_path: String = ""):
	dialogue_list = lines
	current_line_index = 0
	current_speaker = speakerName
	show_dialogue()

func show_dialogue():
	self.visible = true
	choice_container.visible = false
	next_button.visible = true

	var frame = dialogue_list[current_line_index]
	name_label.text = frame.get("name", "")
	text_label.text = frame.get("text", "")

	var img_path = frame.get("portrait", "")
	if img_path != "":
		portrait.texture = load(img_path)
		portrait.visible = true
	else:
		portrait.visible = false

func _on_next_button_pressed():
	current_line_index += 1

	if current_line_index < dialogue_list.size():
		show_dialogue()
	else:
		if current_speaker == "Quest Notice":
			show_quest_choice()
		else:
			finish_dialogue()

func show_quest_choice():
	choice_container.visible = true
	next_button.visible = false
	name_label.text = "System"
	text_label.text = "Will you accept their help?"
	portrait.visible = false

func _on_accept_button_pressed() -> void:
	Global.has_party = true
	Global.difficulty = "Easy"
	Global.story_stage = 3

	var lines = [
		{"name": "Narrator", "text": "Both join as party members. The girl offers healing support, while the boy serves as a tank, protecting the team.", "portrait": ""},
		{"name": Global.player_name, "text": "Great, so… names?", "portrait": ""},
		{"name": "Althea", "text": "Althea!", "portrait": "res://icon.svg"},
		{"name": "Ashton", "text": "Name's Ashton. Looking forward to working with you!", "portrait": "res://icon.svg"}
	]

	start_conversation("Accept_route", lines)

func _on_reject_button_pressed() -> void:
	Global.has_party = false
	Global.difficulty = "Hard"
	Global.story_stage = 3

	var lines = [
		{"name": "Narrator", "text": "They exchange glances, bow awkwardly, and step back, leaving the player to continue alone.", "portrait": ""}
	]

	start_conversation("Reject_route", lines)

func finish_dialogue():
	choice_container.visible = false
	self.visible = false
	Global.is_dialogue_active = false
	dialogue_finished.emit()

	var player = get_tree().current_scene.get_node_or_null("Player")
	if player:
		player.process_mode = Node.PROCESS_MODE_ALWAYS
