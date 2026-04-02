extends Node

# Player Info (Story Script: Name, Gender, Age, Specialization, Background)
var player_name: String = "Hunter"
var gender: String = ""
var specialization: String = ""


# Game State
var has_party: bool = false
var difficulty: String = ""
var is_dialogue_active: bool = false

# story_stage tracks progress: 
# 0 = Just Entered, 1 = Registered, 2 = Read Quest, 3 = Recruited Party
var story_stage: int = 0
