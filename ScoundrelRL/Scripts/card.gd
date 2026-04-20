class_name Card extends Node2D

@onready var value_sprite: Sprite2D = %Value
@onready var card_base_sprite: Sprite2D = %CardBase
@onready var suit_sprite: Sprite2D = %Suit
@onready var button: Button = %Button
@onready var card_display: Node2D = %CardDisplay

@onready var width = card_base_sprite.get_rect().size.x

var valueID: String
var suitID: String
var value: int
var purpose: String
var index: int = 1

var values: Array = ["Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Jack", "Queen", "King"]
var suits: Array = ["Spade", "Club", "Diamond", "Heart"]

func _ready() -> void:
	init_card()

func set_card(i: int) -> void:
	index = i
	valueID = values[i % 13]

	if i <= 13:
		suitID = suits[0]
	elif i <= 26:
		suitID = suits[1]
	elif i <= 39:
		suitID = suits[2]
	else:
		suitID = suits[3]

	if i % 13 == 0:
		value = 14
	else:
		value = i % 13 + 1

	if suitID == "Spade" || suitID == "Club":
		purpose = "Monster"
	elif suitID == "Diamond":
		purpose = "Weapon"
	elif suitID == "Heart":
		purpose = "Heal"

func init_card():
	if value != 14:
		value_sprite.region_rect.position.x = (value - 1) * 5
	if suitID == "Diamond":
		suit_sprite.region_rect.position.x = 0
	elif suitID == "Heart":
		suit_sprite.region_rect.position.x = 5
	elif suitID == "Club":
		suit_sprite.region_rect.position.x = 10
		value_sprite.modulate = Color(0, 0, 0)
	elif suitID == "Spade":
		suit_sprite.region_rect.position.x = 15
		value_sprite.modulate = Color(0, 0, 0)

func _on_button_pressed() -> void:
	Signals.evaluate.emit(self)
