:- dynamic(gameState/4).

set_gameState(IsPowerOn, OxygenLevel, CurrentRoom, Inventory) :- asserta(gameState(IsPowerOn, OxygenLevel, CurrentRoom, Inventory)).
get_gameState(IsPowerOn, OxygenLevel, CurrentRoom, Inventory) :- gameState(IsPowerOn, OxygenLevel, CurrentRoom, Inventory).

gameState_load(Stream, GameState).
gameState_save(Stream, GameState).