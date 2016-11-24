:- dynamic(gameState/4).

init_gameState(IsPowerOn, OxygenLevel, CurrentRoom, Inventory) :- asserta(gameState(IsPowerOn, OxygenLevel, CurrentRoom, Inventory)).

set_isPowerOn(Value) :- 
	retract(gameState(IsPowerOn, OxygenLevel, CurrentRoom, Inventory)),
	asserta(gameState(Value, OxygenLevel, CurrentRoom, Inventory)).

set_oxygenLevel(Value) :- 
	retract(gameState(IsPowerOn, OxygenLevel, CurrentRoom, Inventory)),
	asserta(gameState(IsPowerOn, Value, CurrentRoom, Inventory)).

set_currentRoom(Value) :- 
	retract(gameState(IsPowerOn, OxygenLevel, CurrentRoom, Inventory)),
	asserta(gameState(IsPowerOn, OxygenLevel, Value, Inventory)).

set_inventory(Value) :- 
	retract(gameState(IsPowerOn, OxygenLevel, CurrentRoom, Inventory)),
	asserta(gameState(IsPowerOn, OxygenLevel, CurrentRoom, Value)).

get_isPowerOn(Value) :- gameState(Value, _, _, _).
get_oxygenLevel(Value) :- gameState(_, Value, _, _).
get_currentRoom(Value) :- gameState(_, _, Value, _).
get_inventory(Value) :- gameState(_, _, _, Value).

gameState_load(Stream, GameState).
gameState_save(Stream, GameState).