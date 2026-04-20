class_name Weapon extends Node2D

var weapon_value: int = 0
var monster_value: int = 0

func _ready():
	pass

func reset():
	for i in get_children():
		remove_child(i)
	weapon_value = 0
	monster_value = 0

func new_weapon(card: Card):
	weapon_value = card.value
	monster_value = 0
	for i in get_children():
		remove_child(i)
		Signals.discard.emit(i)
	card.position = Vector2(0, 0)
	add_child(card)

func new_monster(card: Card):
	monster_value = card.value
	var x = get_children().size() * 40
	card.position = Vector2(x, 0)
	add_child(card)
