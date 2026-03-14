extends Node2D
@onready var fade: ColorRect = $HUD/Fade
@onready var score_label: Label = $HUD/ScorePanel/ScoreLabel
@onready var pause_menu: Control = $HUD/PauseMenu
@onready var resume_button: Button = $HUD/PauseMenu/CenterContainer/Panel/VBox/ResumeButton
@onready var exit_button: Button = $HUD/PauseMenu/CenterContainer/Panel/VBox/ExitButton

var level: int = 1
var current_level_root: Node = null
var score: int = 0
var required_score: int = 0

const LEVEL_REQUIREMENTS = {
	1: 2,
	2: 0,
}

func _ready() -> void:
	fade.modulate.a = 1.0
	current_level_root = get_node("LevelRoot")
	level = GameState.start_level
	GameState.start_level = 1

	resume_button.pressed.connect(_on_resume_pressed)
	exit_button.pressed.connect(_on_exit_to_menu_pressed)

	await _load_level(level, true)


#---------------------------
# PAUSE
#---------------------------

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		if get_tree().paused:
			_resume()
		else:
			_pause()

func _pause() -> void:
	get_tree().paused = true
	pause_menu.visible = true

func _resume() -> void:
	get_tree().paused = false
	pause_menu.visible = false

func _on_resume_pressed() -> void:
	_resume()

func _on_exit_to_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")


#---------------------------
# LEVEL MANAGEMENT
#---------------------------

func _load_level(level_number: int, first_load: bool) -> void:
	score = 0
	_update_score_label()

	if not first_load:
		await _fade(1.0)

	if current_level_root:
		current_level_root.queue_free()

	var level_path = "res://scenes/levels/level%s.tscn" % level_number
	current_level_root = load(level_path).instantiate()
	add_child(current_level_root)
	current_level_root.name = "LevelRoot"
	_setup_level(current_level_root)

	await _fade(0.0)


func _setup_level(level_root: Node) -> void:
	var apples = level_root.get_node_or_null("Apples")
	var apple_count = apples.get_child_count() if apples else 0

	var manual_req = LEVEL_REQUIREMENTS.get(level, 0)
	required_score = manual_req if manual_req > 0 else apple_count

	var exit = level_root.get_node_or_null("Exit")
	if exit:
		exit.body_entered.connect(_on_exit_body_entered)

	if apples:
		for apple in apples.get_children():
			apple.collected.connect(increase_score)

	var enemies = level_root.get_node_or_null("Enemies")
	if enemies:
		for enemy in enemies.get_children():
			enemy.player_died.connect(_on_player_died)

	if GameState.is_multiplayer:
		_spawn_player2(level_root)


func _spawn_player2(level_root: Node) -> void:
	var p2_scene = load("res://scenes/player2.tscn")
	if p2_scene == null:
		push_error("player2.tscn not found at res://scenes/player2.tscn")
		return
	var p2 = p2_scene.instantiate()
	p2.name = "Player2"

	var p1 = level_root.get_node_or_null("Player")
	if p1:
		p2.global_position = p1.global_position + Vector2(80, 0)

	level_root.add_child(p2)

	var enemies = level_root.get_node_or_null("Enemies")
	if enemies:
		for enemy in enemies.get_children():
			if not enemy.player_died.is_connected(_on_player_died):
				enemy.player_died.connect(_on_player_died)


#---------------------------
# SIGNAL HANDLERS
#---------------------------

func _on_exit_body_entered(body: Node2D) -> void:
	if body.name == "Player" or body.name == "Player2":
		if score < required_score:
			var needed = required_score - score
			var msg = "You need %d more apple%s to proceed!" % [needed, "s" if needed > 1 else ""]
			_show_notification(msg)
			return

		GameState.complete_level(level)
		level += 1

		var p1 = current_level_root.get_node_or_null("Player")
		var p2 = current_level_root.get_node_or_null("Player2")
		if p1: p1.can_move = false
		if p2: p2.can_move = false

		await _load_level(level, false)


func _on_player_died(body: Node2D) -> void:
	body.die()

	if GameState.is_multiplayer:
		var p1 = current_level_root.get_node_or_null("Player")
		var p2 = current_level_root.get_node_or_null("Player2")
		var p1_dead = p1 == null or !p1.alive
		var p2_dead = p2 == null or !p2.alive
		if p1_dead and p2_dead:
			await get_tree().create_timer(0.5).timeout
			await _load_level(level, false)
	else:
		await get_tree().create_timer(0.5).timeout
		await _load_level(level, false)


#---------------------------
# SCORE
#---------------------------

func increase_score() -> void:
	score += 1
	_update_score_label()

func _update_score_label() -> void:
	score_label.text = "SCORE: %s" % score


#---------------------------
# NOTIFICATION
#---------------------------

func _show_notification(text: String) -> void:
	var notif = current_level_root.get_node_or_null("Notification")
	if notif:
		notif.show_notification(text)


#---------------------------
# FADE
#---------------------------

func _fade(to_alpha: float) -> void:
	var tween := create_tween()
	tween.tween_property(fade, "modulate:a", to_alpha, 1.5)
	await tween.finished
