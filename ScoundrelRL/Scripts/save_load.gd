extends Node

const deck_location = "user://DeckFile.tres"
const choices_location = "user://ChoicesFile.tres"
var save_file_deck: SaveDeck = SaveDeck.new()
var save_file_choices: SaveChoices = SaveChoices.new()

func save_deck():
	ResourceSaver.save(save_file_deck, deck_location)

func load_deck():
	if FileAccess.file_exists(deck_location):
		save_file_deck = ResourceLoader.load(deck_location).duplicate(true)

func save_choices():
	ResourceSaver.save(save_file_choices, choices_location)

func load_choices():
	if FileAccess.file_exists(choices_location):
		save_file_choices = ResourceLoader.load(choices_location).duplicate(true)
