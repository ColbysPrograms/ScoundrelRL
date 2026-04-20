class_name Hand extends ColorRect

var y_min: float = position.y
var y_max: float = size.y + y_min
var width: float = size.x

var offset: float
var cardWidth: float

@export var cardScene: PackedScene

func _ready():
	var card = cardScene.instantiate()
	add_child(card)
	cardWidth = card.width
	offset = (width - 4 * cardWidth)/8
	remove_child(card)
	Signals.connect("draw", add_card)
	Signals.connect("discard", remove_card)

func add_card(card: Card):
	if get_child_count() >= 4:
		return
	self.add_child(card)
	order_cards()

func remove_card(card: Card):
	var card_exists = false
	for i in get_children():
		if i == card:
			card_exists = true
			break
	if card_exists:
		remove_child(card)
	order_cards()
	if get_child_count() == 1:
		Signals.oneCard.emit()

func order_cards():
	var cardCount = get_child_count()
	for i in cardCount:
		var card_x = (cardWidth / 2 + offset + cardWidth * i + offset * 2 * i)
		var card_y = (y_min + y_max) / 2.0
		get_child(i).position = Vector2(card_x,card_y)
