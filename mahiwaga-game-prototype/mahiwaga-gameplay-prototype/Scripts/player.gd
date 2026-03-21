extends CharacterBody2D

const SPEED = 300.0
@onready var wpnPivot = $WeaponPivot
@onready var wpnSlot = $WeaponPivot/WeaponSlot
@onready var weapon = $WeaponPivot/WeaponSlot/Weapon

func update_weapon():
	print("Equipping weapon for: ", Global.specialization)
	
	match Global.specialization:
		"Hunter":
			weapon.texture = load("res://Assets/art/broadsword.png")
		"Mage":
			weapon.texture = load("res://Assets/art/staff.png")
		"Fighter":
			weapon.texture = load("res://Assets/art/battle-ax.png")
		"Supporter":
			weapon.texture = load("res://Assets/art/staff.png")
		"Assassin":
			weapon.texture = load("res://Assets/art/broadsword.png")

# Keep your _ready function simple [cite: 1]
func _ready() -> void:
	print("Welcome, Adventurer", Global.player_name)
	update_weapon()

func _physics_process(delta: float) -> void:
	
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down" )
	
	if direction:
		velocity = direction * SPEED
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)
		
	move_and_slide()
	
	look_at_mouse()
	
func look_at_mouse():
	wpnPivot.look_at(get_global_mouse_position())
	
	var mouse_pos = get_global_mouse_position()
	
	if mouse_pos.x < global_position.x:
		weapon.flip_h = true
	else:
		weapon.flip_h = false
