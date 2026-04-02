extends Control

# WeaponsMenu.gd
# Three weapon cards are shown (Battle Axe, Sword, Magic Staff).
# Pressing "View Info" on any card reveals the DetailOverlay with
# that weapon's image, name, type, and description.
# "← Back to Weapons" hides the overlay and returns to the cards.
# Stats/synergy are intentionally omitted for now (coming soon label shown).

const WEAPONS: Array[Dictionary] = [
	{
		"name": "BATTLE AXE",
		"type": "Melee — Two-Handed",
		"description": "A massive double-headed axe built for raw destructive power. Cleaves through enemy armour and sends foes staggering with every blow. Requires significant strength to wield effectively, but rewards the user with devastating area swings that can hit multiple enemies at once.",
		"image_node": "DetailImage",
		"texture_index": 0,
	},
	{
		"name": "SWORD",
		"type": "Melee — One-Handed",
		"description": "A reliable straight-bladed sword forged for balance and versatility. Favoured across all combat styles for its swift strikes and precise thrusts. Effective against unarmoured and lightly armoured foes, and quick enough to chain into combo attacks.",
		"image_node": "DetailImage",
		"texture_index": 1,
	},
	{
		"name": "MAGIC STAFF",
		"type": "Magic — Two-Handed",
		"description": "An ancient staff crackling with concentrated arcane energy. Channels the wielder's magical power into focused elemental blasts. Capable of striking enemies from great range and excels against groups, with a charged attack that detonates in a wide burst around the impact point.",
		"image_node": "DetailImage",
		"texture_index": 2,
	},
]

# Textures loaded from the scene's ext_resources (matched by card order).
# These are set via _ready() by reading the card ImageRect textures directly.
var _textures: Array[Texture2D] = []

# Node references cached for convenience.
@onready var _cards_container: HBoxContainer = $CardsContainer
@onready var _detail_overlay: PanelContainer = $DetailOverlay
@onready var _detail_image: TextureRect   = $DetailOverlay/DetailScroll/DetailVBox/DetailTopRow/DetailImage
@onready var _detail_name: Label          = $DetailOverlay/DetailScroll/DetailVBox/DetailTopRow/DetailHeaderVBox/DetailName
@onready var _detail_type: Label          = $DetailOverlay/DetailScroll/DetailVBox/DetailTopRow/DetailHeaderVBox/DetailType
@onready var _detail_desc: Label          = $DetailOverlay/DetailScroll/DetailVBox/DetailDescLabel
@onready var _back_from_detail: Button    = $DetailOverlay/DetailScroll/DetailVBox/BackFromDetail
@onready var _back_button: Button         = $BackButton


func _ready() -> void:
	# Cache textures from the card image nodes so we can reuse them in the detail view.
	_textures.append($CardsContainer/CardAxe/VBoxAxe/ImageAxe.texture)
	_textures.append($CardsContainer/CardSword/VBoxSword/ImageSword.texture)
	_textures.append($CardsContainer/CardStaff/VBoxStaff/ImageStaff.texture)

	# Wire View Info buttons.
	$CardsContainer/CardAxe/VBoxAxe/ViewInfoAxe.pressed.connect(_on_view_info.bind(0))
	$CardsContainer/CardSword/VBoxSword/ViewInfoSword.pressed.connect(_on_view_info.bind(1))
	$CardsContainer/CardStaff/VBoxStaff/ViewInfoStaff.pressed.connect(_on_view_info.bind(2))

	# Wire back buttons.
	_back_from_detail.pressed.connect(_on_back_from_detail)
	_back_button.pressed.connect(_on_back_pressed)


func _on_view_info(index: int) -> void:
	var w: Dictionary = WEAPONS[index]

	_detail_image.texture = _textures[index]
	_detail_name.text     = w["name"]
	_detail_type.text     = w["type"]
	_detail_desc.text     = w["description"]

	_cards_container.visible = false
	_detail_overlay.visible  = true


func _on_back_from_detail() -> void:
	_detail_overlay.visible  = false
	_cards_container.visible = true


func _on_back_pressed() -> void:
	# If detail is open, go back to cards first; otherwise leave the scene.
	if _detail_overlay.visible:
		_on_back_from_detail()
	else:
		SceneTransition.fade_to("res://scenes/PlayMenu.tscn")
