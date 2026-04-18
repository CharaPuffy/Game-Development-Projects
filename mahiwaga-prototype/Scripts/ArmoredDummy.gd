extends StaticBody2D

# ArmoredDummy.gd
# A tougher dummy that has a Defense stat.
# Defense reduces physical (sword) damage by 1 per point.
# Magic (staff projectile) damage is not affected.

const MAX_HP := 30
const DEFENSE := 6

var hp := MAX_HP

@onready var hp_label: Label = $HPLabel
@onready var def_label: Label = $DefLabel
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	_update_display()

# is_magic: pass true for staff projectile damage (bypasses defense)
func take_damage(amount: int, is_magic: bool = false) -> void:
	var final_damage := amount
	if not is_magic:
		final_damage = max(1, amount - DEFENSE)
	hp -= final_damage
	if hp <= 0:
		hp = MAX_HP
	_update_display()
	_flash()

func _update_display() -> void:
	if hp_label:
		hp_label.text = "HP: %d / %d" % [hp, MAX_HP]
	if def_label:
		def_label.text = "DEF: %d" % DEFENSE

func _flash() -> void:
	sprite.modulate = Color(1, 0.2, 0.2)
	await get_tree().create_timer(0.15).timeout
	sprite.modulate = Color(1, 1, 1)
