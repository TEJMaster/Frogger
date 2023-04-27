# Frogger
Frogger Game using MIPS Assembly

# Game Controls 

In this game, you will control a frog as it navigates the play area using the WASD input keys:

- **W**: Move the frog upward
- **A**: Move the frog leftward
- **S**: Move the frog downward
- **D**: Move the frog rightward

This project utilizes the Keyboard and MMIO Simulator for processing keyboard inputs. Apart from the aforementioned keys, it is also beneficial to use an additional key, such as **R**, for starting and restarting the game when necessary.

When no keys are pressed, the frog remains stationary at its current position on the screen. If the frog's movement, triggered by a key press, causes it to collide with a vehicle on the lower half of the screen or enter the water in the upper half, the frog will be reset to the safe row at the bottom of the screen.

# Additional Features Implemented

- Display the number of lives remaining. 
- After final player death, display game over/retry screen. Restart the game if the “retry” option is chosen.
- Make objects (frog, logs, turtles, vehicles, etc) look more like the arcade version.
- Have objects in different rows move at different speeds
- Add a third row in each of the water and road sections.
- Display a death/respawn animation each time the player loses a frog.
- Add sound effects for movement, losing lives, collisions, and reaching the goal.
