extends Node2D

# TutorialWorld.gd
# Tutorial stage: player starts with no weapon, picks up Sword or Staff via [E].
# Three dummies present; one is an ArmoredDummy (DEF 6, reduces physical damage).
# Narrative dialogue greets the player on entry.
# Esc opens a pause menu with Resume, Settings, and Exit to Main Menu.

@onready var esc_panel: ColorRect = $EscMenu/Blocker
@onready var esc_popup: PanelContainer = $EscMenu/Panel
@onready var dialogue_ui = $DialogueUI
@onready var player = $TutorialPlayer
@onready var hud_weapon_label: Label = $HUD/WeaponLabel
@onready var hud_hint_label: Label = $HUD/HintLabel

var is_menu_open := false

# ── Tutorial narrative lines ────────────────────────────────────────────────
const TUTORIAL_LINES := [
	{
		"name": "Guide",
		"text": "Welcome, adventurer! You have entered the Tutorial Grounds. Here you will learn everything you need to know before setting off into the world.",
		"portrait": ""
	},
	{
		"name": "Guide",
		"text": "First, let us talk about movement. Use W, A, S, and D to move around. Your character will follow your direction smoothly.",
		"portrait": ""
	},
	{
		"name": "Guide",
		"text": "You arrive here without a weapon. Two weapons are available for you to try — the Sword and the Staff. Approach either one and press [E] to equip it.",
		"portrait": ""
	},
	{
		"name": "Guide",
		"text": "The Sword is a melee weapon. Walk close to a dummy and click the left mouse button to swing it. Each hit deals 5 physical damage.",
		"portrait": ""
	},
	{
		"name": "Guide",
		"text": "The Staff fires a magic projectile. Click the left mouse button and a bolt of energy will fly toward your cursor, dealing 3 magic damage on impact.",
		"portrait": ""
	},
	{
		"name": "Guide",
		"text": "You can switch weapons at any time by pressing [E] near the other weapon on the ground. Your current weapon will be replaced instantly.",
		"portrait": ""
	},
	{
		"name": "Guide",
		"text": "Now, notice the three training dummies ahead. Two are standard dummies. The third — the blue one — is an Armored Dummy with 6 points of Defense.",
		"portrait": ""
	},
	{
		"name": "Guide",
		"text": "Defense reduces physical damage by 1 for every point. Your Sword deals 5 damage, so the Armored Dummy takes only 1 damage per swing. Magic from the Staff ignores Defense entirely.",
		"portrait": ""
	},
	{
		"name": "Guide",
		"text": "That is all for now. Step forward, pick up a weapon, and begin your training. Press [Esc] at any time to pause or return to the main menu. Good luck!",
		"portrait": ""
	}
]

func _ready() -> void:
	esc_panel.visible = false
	esc_popup.visible = false

	$EscMenu/Panel/VBox/ResumeBtn.pressed.connect(_close_menu)
	$EscMenu/Panel/VBox/SettingsBtn.pressed.connect(_on_settings)
	$EscMenu/Panel/VBox/ExitBtn.pressed.connect(_on_exit)

	# HUD weapon tracking
	hud_weapon_label.text = "Weapon: None"
	hud_hint_label.text = "Move: WASD  |  Attack: Left Click  |  Equip: [E] near weapon  |  Pause: Esc"

	# Start dialogue after a short delay so the scene finishes loading
	await get_tree().create_timer(0.4).timeout
	_start_tutorial_dialogue()

func _start_tutorial_dialogue() -> void:
	dialogue_ui.start_conversation("Tutorial", TUTORIAL_LINES)
	dialogue_ui.dialogue_finished.connect(_on_dialogue_finished, CONNECT_ONE_SHOT)

func _on_dialogue_finished() -> void:
	pass  # Player is free to explore after dialogue ends

func _process(_delta: float) -> void:
	# Keep HUD weapon label updated
	if player and is_instance_valid(player):
		var wpn = player.current_weapon
		hud_weapon_label.text = "Weapon: %s" % ("None" if wpn == "" else wpn)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if is_menu_open:
			_close_menu()
		else:
			_open_menu()

func _open_menu() -> void:
	is_menu_open = true
	esc_panel.visible = true
	esc_popup.visible = true
	get_tree().paused = true

func _close_menu() -> void:
	is_menu_open = false
	esc_panel.visible = false
	esc_popup.visible = false
	get_tree().paused = false

func _on_settings() -> void:
	pass

func _on_exit() -> void:
	get_tree().paused = false
	SceneTransition.fade_to("res://scenes/MainMenu.tscn")
