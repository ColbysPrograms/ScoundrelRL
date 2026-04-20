extends Node

@warning_ignore("unused_signal")
signal discard(card: Card)
@warning_ignore("unused_signal")
signal draw(card: Card)
@warning_ignore("unused_signal")
signal evaluate(card: Card)
@warning_ignore("unused_signal")
signal oneCard()
@warning_ignore("unused_signal")
signal gameOver()
@warning_ignore("unused_signal")
signal playAgain()
@warning_ignore("unused_signal")
signal run()

func check_card(card: Card):
	print("Index:   " + str(card.index))
	print("ValueID: " + str(card.valueID))
	print("Value:   " + str(card.value))
	print("SuitID:  " + str(card.suitID))
	print("Purpose: " + str(card.purpose) + "\n")
