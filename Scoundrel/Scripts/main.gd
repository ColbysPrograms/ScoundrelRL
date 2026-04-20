class_name Main extends Node2D

@onready var hand: ColorRect = %Hand
@onready var deck: Deck = %Deck
@onready var discard: Node2D = %Discard
@onready var weapon: Weapon = %Weapon
@onready var health: Label = %Health
@onready var game_over: GameOver = %"Game Over"
@onready var run_button: Button = %RunButton

var score: int = 0

func _ready():
	Signals.connect("evaluate", evaluate)
	Signals.connect("oneCard", fill_hand)
	Signals.connect("gameOver", end_game)
	Signals.connect("playAgain", start_game)
	Signals.connect("run", run_from_room)
	deck.initialize_deck()
	start_game()

func start_game():
	health.restart()
	fill_hand()

func fill_hand():
	while hand.get_child_count() < 4:
		if deck.cards.size() == 0:
			deck.modulate.a = 0
			break
		Signals.draw.emit(deck.cards.front())
	run_button.disabled = false

func evaluate(card: Card):
	run_button.disabled = true
	hand.remove_card(card)
	if card.purpose == "Weapon":
		weapon.new_weapon(card)
	elif card.purpose == "Heal":
		health.add(card.value)
		discard.add_card(card)
	elif card.purpose == "Monster":
		var damage: int = 0
		if weapon.weapon_value == 0:
			damage = card.value
			discard.add_card(card)
		elif weapon.monster_value == 0 || weapon.monster_value >= card.value:
			damage = clamp(card.value - weapon.weapon_value, 0, 20)
			weapon.new_monster(card)
		elif weapon.monster_value < card.value:
			damage = card.value
			discard.add_card(card)
		health.add(-damage)
		if health.value == 0:
			end_game()
	if deck.cards.size() == 0 && hand.get_child_count() == 0:
		end_game()

func end_game():
	game_over.visible = true
	if health.value > 0:
		game_over.set_text("WIN!!!")
		score = get_score(true)
	else:
		score = get_score(false)
		game_over.set_text("LOSE!!!")
	reset()
	Signals.playAgain.emit()

func reset():
	deck.modulate.a = 255
	for i in hand.get_children():
		hand.remove_child(i)
	for i in discard.get_children():
		discard.remove_child(i)
	weapon.reset()
	deck.reshuffle()

func run_from_room():
	var current_hand = hand.get_children()
	for i in hand.get_children():
		hand.remove_child(i)
	for i in current_hand:
		deck.cards.append(i)
	fill_hand()
	run_button.disabled = true

func get_score(win: bool) -> int:
	if win:
		return health.value
	else:
		return -get_monster_count()

func get_monster_count() -> int:
	var monsters: int = 0
	for i in deck.cards:
		if i.purpose == "Monster":
			monsters += i.value
	for i in hand.get_children():
		if i.purpose == "Monster":
			monsters += i.value
	return monsters
