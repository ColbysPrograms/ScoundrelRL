class_name Discard extends Node2D

func _ready() -> void:
	Signals.connect("discard", add_card)

func add_card(card: Card) -> void:
	if get_children().size() > 0:
		remove_child(get_child(0))
	card.position = Vector2(0, 0)
	add_child(card)
