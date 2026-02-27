extends Area2D

signal player_died # This matches what main.gd looks for

func _on_body_entered(body: Node2D) -> void:
	# Check if it's the player and if they are still alive
	if body.name == "Player" and body.alive:
		player_died.emit(body)
