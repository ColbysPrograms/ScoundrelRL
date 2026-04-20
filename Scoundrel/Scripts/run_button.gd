class_name Run extends Button

func _ready() -> void:
	pass

func _on_pressed() -> void:
	Signals.run.emit()
