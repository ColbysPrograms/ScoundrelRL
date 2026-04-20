class_name Deck extends Sprite2D

@export var cardScene: PackedScene

var cards: Array[Card]
var initialDeck: Array[Card]

func _ready() -> void:
	Signals.connect("draw", remove_card)

func reshuffle():
	cards = initialDeck.duplicate()
	cards.shuffle()

func initialize_deck():
	var deck_index: Array[int]
	for i in range(1, 53):
		deck_index.append(i)
	for i in deck_index:
		var card: Card = cardScene.instantiate()
		card.set_card(i)
		cards.append(card)
	remove_red()
	cards.shuffle()
	initialDeck = cards.duplicate()

func remove_red() -> void:
	var red: Array[Card]
	for i in cards:
		if i.suitID == "Heart" && i.value >= 11:
			red.append(i)
		elif i.suitID == "Diamond" && i.value >= 11:
			red.append(i)
	for i in red:
		cards.erase(i)

func remove_card(card: Card) -> void:
	cards.erase(card)
