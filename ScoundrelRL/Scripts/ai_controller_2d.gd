extends AIController2D

@onready var main: Main = $".."
@onready var hand: Hand = %Hand
@onready var health: Health = %Health
@onready var weapon: Weapon = %Weapon
@onready var run_button: Run = %RunButton

func get_obs() -> Dictionary:
	var obs: Array[int] = []
	obs.append(health.value)
	obs.append(weapon.weapon_value)
	obs.append(weapon.monster_value)
	obs.append(run_button.disabled)
	#for i in range(4):
		#if i <= hand.get_children().size() - 1:
			#obs.append(1)
		#else:
			#obs.append(0)
	for i in hand.get_children():
		#obs.append(i.value)
		if i.purpose == "Monster":
			obs.append(1)
		if i.purpose == "Weapon":
			obs.append(2)
		if i.purpose == "Heal":
			obs.append(3)
	while obs.size() < 12:
		obs.append(0)
	return {"obs":obs}

func get_reward() -> float:
	return reward

func get_action_space() -> Dictionary:
	return {"choice" : {"size": 5, "action_type": "discrete"}}

func set_action(action) -> void:
	main.action = action.choice
