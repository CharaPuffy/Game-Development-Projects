extends CharacterBody2D

# TutorialPlayer.gd
# Same as player.gd but starts with NO weapon.
# Pressing E near a weapon pickup equips it; pressing E again on a different pickup switches.

const SPEED = 300.0

@onready var wpnPivot = $WeaponPivot
@onready var wpnSlot = $WeaponPivot/WeaponSlot
@onready var weapon = $WeaponPivot/WeaponSlot/Weapon
@onready var sword_hitbox = $WeaponPivot/WeaponSlot/SwordHitbox

var projectile_scene: PackedScene

# Sword swing state
var sword_swinging := false
var swing_angle := 0.0
var swing_dir := 1.0
const SWING_SPEED := 8.0
const SWING_ARC := 90.0

# Tutorial: no weapon equipped at start
# "Sword", "Staff", or "" (none)
var current_weapon: String = ""

# Nearby pickup node (set by TutorialWorld)
var nearby_pickup: Node = null

func _ready() -> void:
	projectile_scene = load("res://scenes/StaffProjectile.tscn")
	sword_hitbox.monitoring = false
	sword_hitbox.get_node("CollisionShape2D").disabled = true
	# Hide weapon sprite until equipped
	weapon.visible = false

func equip_weapon(weapon_name: String) -> void:
	current_weapon = weapon_name
	weapon.visible = true
	match weapon_name:
		"Sword":
			weapon.texture = load("res://Assets/art/broadsword.png")
		"Staff":
			weapon.texture = load("res://Assets/art/staff.png")

func _is_staff() -> bool:
	return current_weapon == "Staff"

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)
	move_and_slide()
	look_at_mouse()

	# Sword swing animation tick
	if sword_swinging:
		swing_angle += swing_dir * SWING_SPEED * delta * 60.0
		wpnSlot.rotation_degrees = swing_angle
		if abs(swing_angle) >= SWING_ARC:
			swing_dir *= -1.0
			if swing_angle < 0.0:
				sword_swinging = false
				swing_angle = 0.0
				wpnSlot.rotation_degrees = 0.0
				sword_hitbox.monitoring = false
				sword_hitbox.get_node("CollisionShape2D").disabled = true
				sword_hitbox.reset_swing()

func _input(event: InputEvent) -> void:
	# E key: equip nearby weapon
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_E:
			if nearby_pickup != null and nearby_pickup.has_method("get_weapon_name"):
				equip_weapon(nearby_pickup.get_weapon_name())

	# Left click: attack if weapon equipped
	if event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and event.pressed:
		if current_weapon == "":
			return
		if _is_staff():
			_fire_projectile()
		else:
			_swing_sword()

func _swing_sword() -> void:
	if sword_swinging:
		return
	sword_swinging = true
	swing_angle = 0.0
	swing_dir = 1.0
	wpnSlot.rotation_degrees = 0.0
	sword_hitbox.monitoring = true
	sword_hitbox.get_node("CollisionShape2D").disabled = false
	sword_hitbox.reset_swing()

func _fire_projectile() -> void:
	if projectile_scene == null:
		return
	var proj = projectile_scene.instantiate()
	get_parent().add_child(proj)
	proj.global_position = weapon.global_position
	proj.direction = (get_global_mouse_position() - weapon.global_position).normalized()

func look_at_mouse():
	wpnPivot.look_at(get_global_mouse_position())
	var mouse_pos = get_global_mouse_position()
	if mouse_pos.x < global_position.x:
		weapon.flip_h = true
	else:
		weapon.flip_h = false
