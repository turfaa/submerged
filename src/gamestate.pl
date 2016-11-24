:- dynamic(gameState/5).

set_isPowerOn(Value) :-
	retract(gameState(_, OxygenLevel, CurrentRoom, Inventory, Objects)),
	asserta(gameState(Value, OxygenLevel, CurrentRoom, Inventory, Objects)).

set_oxygenLevel(Value) :- 
	retract(gameState(IsPowerOn, _, CurrentRoom, Inventory, Objects)),
	asserta(gameState(IsPowerOn, Value, CurrentRoom, Inventory, Objects)).

set_currentRoom(Value) :- 
	retract(gameState(IsPowerOn, OxygenLevel, _, Inventory, Objects)),
	asserta(gameState(IsPowerOn, OxygenLevel, Value, Inventory, Objects)).

set_inventory(Value) :- 
	retract(gameState(IsPowerOn, OxygenLevel, CurrentRoom, _, Objects)),
	asserta(gameState(IsPowerOn, OxygenLevel, CurrentRoom, Value, Objects)).

set_objects(Value) :-
	retract(gameState(IsPowerOn, OxygenLevel, CurrentRoom, Inventory, _)),
	asserta(gameState(IsPowerOn, OxygenLevel, CurrentRoom, Inventory, Value)).

get_isPowerOn(Value) :- gameState(Value, _, _, _, _).
get_oxygenLevel(Value) :- gameState(_, Value, _, _, _).
get_currentRoom(Value) :- gameState(_, _, Value, _, _).
get_inventory(Value) :- gameState(_, _, _, Value, _).
get_objects(Value) :- gameState(_, _, _, _, Value).

/*gameState_load(Stream, GameState).
gameState_save(Stream, GameState).*/

/* Initial game state */

init_gameState :-
	asserta(gameState(0, 10, 'Weapons room', [], [

		['barrels', 'Weapons room', 0],
		['explosives', 'Weapons room', 0],
		['weapons', 'Weapons room', 1],

		['sonar display', 'Sonar room', 1],
		['airlock inner hatch', 'Sonar room', 1],
		['headphones', 'Sonar room', 0]

	])).

/*
### Airlock

- Airlock outer hatch: permanently jammed.

### Crew quarters

- Book: -
- Canned food: -
- Bucket: -
- Knife: -

### Wardroom

- Intelligence documents: contains explosives arming code
- Ship's log: story

### Storage room

- Diving equipment: required to survive flooding.
- Oxygen canisters: replenish oxygen level (if oxygen level too low, the player will die).
- Crowbar: used to break hole in the reactor.

### Control room

- Control panel: lock/unlock all hatches (except jammed ones). Requires power to function.
- Map: story
- Radio: reveals secondary objective. Requires power to function.
- Periscope: -

### Engine room

- Fuse box: turn on backup power
- Reactor status display: shows that the reactor room is flooded (can exit through hole).
- Engine spare parts: -
- Fire extinguisher: will reduce oxygen level if used.
- Oxygen canister: replenish oxygen level

### Reactor

- Hole: initially too small to pass through, must equip crowbar to break through.
- Engine: -
- Dead engineer: -
*/