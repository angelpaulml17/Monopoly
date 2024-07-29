# Monopolee Game Database Project

## Overview

This project models the gameplay of a simplified version of Monopoly called Monopolee using a relational database and SQL queries. The database and queries are designed to be compatible with SQLite.


## Files

- `create.sql`: Contains queries to create the database with correct constraints.
- `populate.sql`: Contains queries to populate the database with the initial state.
- `q1.sql` to `q8.sql`: Simulates gameplay for each turn.
- `view.sql`: Creates a SQL view to display the current status of the game.

## Database Design

### ER Diagram

- **Players**: Information about each player, including id, name, token, bank balance, current location, and any bonuses.
- **Properties**: Details about each property, including name, cost, color, and owner.
- **Bonuses**: Information about bonuses (Chance, Community Chest, and corners) including id, name, and description.
- **Audit Trail**: Records each turn taken by a player, including player id, location landed on, current bank balance, and game round number.

### Schema

- **Players**: 
  - `id`: Unique identifier for each player.
  - `name`: Name of the player.
  - `token`: Chosen token (e.g., dog, car).
  - `bank_balance`: Player's current bank balance.
  - `current_location`: Player's current location on the board.
  - `bonus`: Any bonus currently held by the player.

- **Properties**: 
  - `name`: Unique name of the property.
  - `cost`: Purchase cost of the property.
  - `color`: Color group of the property.
  - `owner`: Current owner of the property (can be null).

- **Bonuses**: 
  - `id`: Unique identifier for the bonus.
  - `name`: Name of the bonus (e.g., Chance 1).
  - `description`: Textual description of the bonus effect.

- **Audit Trail**: 
  - `player_id`: Identifier of the player.
  - `location`: Location landed on.
  - `bank_balance`: Player's bank balance after the turn.
  - `game_round`: Number of the game round.

## Gameplay Simulation

### Initial State

Properties and bonuses are initialized with predefined values. Players start with specific tokens, locations, bank balances, and properties.

### Rules

- **R1**: Players must buy unowned properties they land on.
- **R2**: Players pay rent to property owners; double rent if the owner has all properties of the same color.
- **R3**: Players in jail roll a 6 to get out and roll again.
- **R4**: Passing or landing on GO gives the player £200.
- **R5**: Rolling a 6 allows the player to move 6 squares and roll again.
- **R6**: Landing on "Go to Jail" sends the player to Jail without passing GO.
- **R7**: Actions for landing on Chance or Community Chest locations are executed.

### Gameplay Rounds

- **Round 1**: 
  - G1: Jane rolls a 3.
  - G2: Norman rolls a 1.
  - G3: Mary rolls a 4.
  - G4: Bill rolls a 2.

- **Round 2**: 
  - G5: Jane rolls a 5.
  - G6: Norman rolls a 4.
  - G7: Mary rolls a 6, then a 5.
  - G8: Bill rolls a 6, then a 3.

## SQL Scripts

1. **create.sql**: Create tables with constraints.
2. **populate.sql**: Insert initial data.
3. **q1.sql** to **q8.sql**: Simulate each gameplay turn.
4. **view.sql**: Create a view displaying the current status of each player.

## Conclusion

This project demonstrates how to model and simulate a simplified Monopoly game using SQLite. It covers database design, schema creation, data population, and game state manipulation through SQL.

