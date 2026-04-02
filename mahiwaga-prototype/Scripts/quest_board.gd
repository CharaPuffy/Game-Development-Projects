extends StaticBody2D

var is_player_in_range: bool = false

@onready var quest_area = $InteractionArea


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	quest_area.body_entered.connect(_on_player_entered)
	quest_area.body_exited.connect(_on_player_exited)

func _on_player_entered(body):
	if body.name == "Player":
		is_player_in_range = true
		print("Press E to enter quests..")
		
func _on_player_exited(body):
	if body.name == "Player":
		is_player_in_range =  false

func _input(event):
	if is_player_in_range and event.is_action_pressed("interact"):
		start_quest_dialogue()
		
		
func start_quest_dialogue():
	var ui = get_tree().current_scene.get_node("DialogueUI")
	
	# Specific script for the [F] Rank Quest Notice
	var full_script = [
	{ "name": "Quest Board", "text": "[Quest Notice]\nRank: F...", "portrait": "" },
	{ "name": "Narrator", "text": "The first is a pink-haired girl with a staff strapped to her back. She smiles nervously, clutching it tightly.", 
	"portait": ""},
	{ "name": "Pink-Haired Girl", "text": "Hello! Could we perhaps join you?", "portrait": "res://icon.svg" },
	{ "name": "Narrator", "text": "Then, as if afraid of rejection, she quickly adds,", "portait": ""},
	{ "name": "Pink-Haired Girl", "text": "I-I can heal you if you’re ever in trouble!", "portrait": "res://icon.svg" },
	{ "name": "Narrator", "text": "Beside her stands a tall boy with short silver hair, clad in reinforced armor. A heavy shield rests on his arm, and his calm expression radiates confidence.", "portait": ""},
	{ "name": "Silver Hair Boy", "text": "And I’ll be your shield,” he says firmly. “If something tries to tear you apart, it’ll have to go through me first.", "portrait": "res://icon.svg"}
	]
	Global.story_stage = 2 # Player has read the quest
	ui.start_conversation("Quest Notice", full_script)
	
	
