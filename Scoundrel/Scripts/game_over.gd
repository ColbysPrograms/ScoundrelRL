class_name GameOver extends CanvasLayer

@onready var label: Label = %Label
@onready var button: Button = %Button

func _ready() -> void:
	pass

func _on_button_pressed() -> void:
	visible = false
	Signals.playAgain.emit()

func set_text(newText: String):
	label.text = newText
