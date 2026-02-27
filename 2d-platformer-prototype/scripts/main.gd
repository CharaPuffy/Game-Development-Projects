extends Node2D
@onready var fade: ColorRect = $HUD/Fade
@onready var score_label: Label = $HUD/ScorePanel/ScoreLabel

var level: int = 1
var current_level_root: Node = null
var score: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#setup the level
	fade.modulate.a = 1.0
	current_level_root = get_node("LevelRoot")
	await _load_level(level, true)




#---------------------------
#LEVEL MANAGEMENT
#---------------------------

func _load_level(level_number: int, first_load: bool) -> void:
	#fade out
	if not first_load:
		await _fade(1.0)

	if current_level_root:
		current_level_root.queue_free()

	#Change level
	var level_path = "res://scenes/levels/level%s.tscn" % level_number
	current_level_root = load(level_path).instantiate()
	add_child(current_level_root)
	current_level_root.name = "LevelRoot"
	_setup_level(current_level_root)

	#fade in
	await _fade(0.0)


func _setup_level(level_root: Node) -> void:
	#connect Exit
	var exit = level_root.get_node_or_null("Exit")
	if exit:
		exit.body_entered.connect(_on_exit_body_entered)

#connect apples
	var apples = level_root.get_node_or_null("Apples")
	if apples:
		for enemy in apples.get_children():
			enemy.collected.connect(increase_score)

	# connect enemies
	var enemies = level_root.get_node_or_null("Enemies")
	if enemies:
		for enemy in enemies.get_children():
			enemy.player_died.connect(_on_player_died)




#---------------------------
# SIGNAL HANDLERS
#---------------------------

func _on_exit_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		level += 1
		body.can_move = false
		await _load_level(level, false)

func _on_player_died(body):
	body.die()
	await get_tree().create_timer(0.5).timeout
	await _load_level(level, false)




#---------------------------
# SCORE
#---------------------------

func increase_score() -> void:
	score += 1
	score_label.text = "SCORE: %s" % score




#---------------------------
#FADE
#---------------------------

func _fade(to_alpha: float) -> void:
	var tween := create_tween()
	tween.tween_property(fade, "modulate:a", to_alpha, 1.5)
	await tween.finished
