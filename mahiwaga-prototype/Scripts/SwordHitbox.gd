extends Area2D

# Tracks which targets were already hit this swing (prevents multi-hit spam)
var _hit_this_swing: Array[Node] = []

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func reset_swing() -> void:
	_hit_this_swing.clear()

func _on_area_entered(area: Area2D) -> void:
	var target = area.get_parent()
	if target in _hit_this_swing:
		return
	if target.has_method("take_damage"):
		_hit_this_swing.append(target)
		# Physical damage — pass is_magic = false so ArmoredDummy reduces it
		target.take_damage(5, false)
