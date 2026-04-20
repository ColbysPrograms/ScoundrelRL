# ScoundrelRL
There are two Godot projects uploaded. The first (Scoundrel) is just the base game without any of the Reinforcement Learning elements. The second (ScoundrelRL) includes all of the Reinforcement Learning elements and can be used with run_model.py to perform reinforcement learning with the game.

## Scoundrel Game
The game itself can be played at <garfoo.itch.io/scoundrel>

## Reinforcment Learning Guide
To use this project:
1. Generate a deck with the game. This can be done by enabling the save_deck() comment in main.gd.
2. Generate a virtual environment and install the godot-rl package with pip or another package manager.
3. Make sure the sync node is in training and run the run_model.py file and start the game in Godot.

The file can be ran on its own by exporting the Godot project and using the --env_path argument with the run_model.py file. More information on this can be found at [Godot RL Agents](https://github.com/edbeeching/godot_rl_agents)
