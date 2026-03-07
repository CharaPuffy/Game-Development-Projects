extends CanvasLayer
# =============================================================
# touch_hud.gd
#
# Automatically hides the entire touch HUD on PC/desktop and
# shows it only on touchscreen devices (Android, iOS).
#
# HOW IT WORKS:
#   Godot's OS.has_feature("mobile") returns true on Android/iOS.
#   DisplayServer.is_touchscreen_available() also checks for
#   real touch hardware.
#   On PC neither is true so we hide the whole CanvasLayer,
#   meaning zero buttons show on Windows export.
#   On Android both are true so buttons show normally.
# =============================================================

func _ready() -> void:
	if OS.has_feature("mobile") or DisplayServer.is_touchscreen_available():
		# Real touch device — show buttons
		visible = true
	else:
		# PC / desktop — hide entire HUD including all buttons
		visible = false
