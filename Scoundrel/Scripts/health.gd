class_name Health extends Label

var value: int = 20:
	set(new_health):
		value = new_health
		text = "Health: " + str(new_health)

func _ready() -> void:
	pass

func add(change):
	var new_health = clamp(value + change, 0, 20)
	value = new_health

func restart():
	value = 20
