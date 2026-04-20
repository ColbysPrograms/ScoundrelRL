class_name Main extends Node2D

@onready var hand: ColorRect = %Hand
@onready var deck: Deck = %Deck
@onready var discard: Node2D = %Discard
@onready var weapon: Weapon = %Weapon
@onready var health: Label = %Health
@onready var run_button: Button = %RunButton
@onready var ai_controller_2d: Node2D = %AIController2D
@onready var ai_controller: Node = %AIController

var action: int = -1
var score: int = 0
var trials: int = 0
var wins: int = 0
var reward: int = 0:
	set(new_reward):
		reward = new_reward
		ai_controller_2d.reward = new_reward
var done: bool = false:
	set(is_done):
		done = is_done
		ai_controller_2d.done = is_done
		ai_controller_2d.needs_reset = is_done
var choices: Array[int] = []

func _ready():
	Signals.connect("evaluate", evaluate)
	Signals.connect("oneCard", fill_hand)
	Signals.connect("gameOver", end_game)
	Signals.connect("playAgain", start_game)
	Signals.connect("run", run_from_room)
	deck.initialize_deck()
	#save_deck()
	load_deck()
	start_game()

func save_deck():
	SaveLoad.save_file_deck.cards = deck.cards as Array[Card]
	SaveLoad.save_deck()

func load_deck():
	SaveLoad.load_deck()
	var saved_deck = SaveLoad.save_file_deck.cards
	for i in saved_deck.size():
		deck.cards[i].set_card(saved_deck[i].index)

func save_choices():
	SaveLoad.save_file_choices.choices = choices
	SaveLoad.save_file_choices.best_score = score
	SaveLoad.save_choices()

func best_score() -> int:
	SaveLoad.load_choices()
	return SaveLoad.save_file_choices.best_score

func _process(_delta: float) -> void:
	if ai_controller_2d.needs_reset:
		ai_controller_2d.reset()
		return

func _physics_process(_delta: float) -> void:
	reward = 0
	done = false
	var previous_monster_count: int = get_monster_count()
	var cards = hand.get_children()
	if action == 0:
		if !run_button.disabled:
			choices.append(action)
			run_from_room()
	elif action > 0:
		if action <= cards.size():
			choices.append(action)
			evaluate(cards[action - 1])
	var current_monster_count: int = get_monster_count()
	if done:
		if best_score() < score:
			save_choices()
		choices = []
		previous_monster_count = current_monster_count
	reward += previous_monster_count - current_monster_count

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
	done = true
	trials += 1
	if health.value > 0:
		wins += 1
		score = get_score(true)
	else:
		score = get_score(false)
	printt('Trials: ' + str(trials), '  Wins: ' + str(wins), '  Score: ' + str(score))
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
