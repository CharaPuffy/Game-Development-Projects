extends Node2D

@onready var player = $Player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.global_position = Vector2(400, 500)
	
	print("Welcome to Anti-Mythics Guilds, ", Global.player_name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_quest_accepted():
	var althea = preload("res://Scenes/NPCS/althea.tscn").instantiate()
	var ashton = preload("res://Scenes/NPCS/ashton.tscn").instantiate()
	
	add_child(althea)
	add_child(ashton)
	althea.global_position = player.global_position + Vector2(-50, 50)
	ashton.global_position = player.global_position + Vector2(50, 50)
