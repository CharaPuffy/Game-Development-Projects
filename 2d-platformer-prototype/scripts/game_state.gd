extends Node

# Which level to start on when main.tscn loads
var start_level: int = 1

# Tracks which levels have been successfully completed
# e.g. levels_completed[1] = true means Level 1 has been beaten
var levels_completed: Dictionary = {}

# Whether we are in 2-player local mode
var is_multiplayer: bool = false

func complete_level(level_number: int) -> void:
	levels_completed[level_number] = true

func is_level_unlocked(level_number: int) -> bool:
	# Level 1 is always unlocked
	if level_number == 1:
		return true
	# Any other level requires the previous one to be completed
	return levels_completed.get(level_number - 1, false)
