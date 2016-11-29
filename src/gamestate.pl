:- dynamic(gameState/7).

set_isPowerOn(Value) :-
	retract(gameState(_, OxygenLevel, CurrentRoom, Inventory, Objects, ExplosiveTimer, Distance)),
	asserta(gameState(Value, OxygenLevel, CurrentRoom, Inventory, Objects, ExplosiveTimer, Distance)).

set_oxygenLevel(Value) :-
	retract(gameState(IsPowerOn, _, CurrentRoom, Inventory, Objects, ExplosiveTimer, Distance)),
	asserta(gameState(IsPowerOn, Value, CurrentRoom, Inventory, Objects, ExplosiveTimer, Distance)).

set_currentRoom(Value) :-
	retract(gameState(IsPowerOn, OxygenLevel, _, Inventory, Objects, ExplosiveTimer, Distance)),
	asserta(gameState(IsPowerOn, OxygenLevel, Value, Inventory, Objects, ExplosiveTimer, Distance)).

set_inventory(Value) :-
	retract(gameState(IsPowerOn, OxygenLevel, CurrentRoom, _, Objects, ExplosiveTimer, Distance)),
	asserta(gameState(IsPowerOn, OxygenLevel, CurrentRoom, Value, Objects, ExplosiveTimer, Distance)).

set_objects(Value) :-
	retract(gameState(IsPowerOn, OxygenLevel, CurrentRoom, Inventory, _, ExplosiveTimer, Distance)),
	asserta(gameState(IsPowerOn, OxygenLevel, CurrentRoom, Inventory, Value, ExplosiveTimer, Distance)).

set_explosiveTimer(Value) :-
	retract(gameState(IsPowerOn, OxygenLevel, CurrentRoom, Inventory, Objects, _, Distance)),
	asserta(gameState(IsPowerOn, OxygenLevel, CurrentRoom, Inventory, Objects, Value, Distance)).

set_distance(Value) :-
	retract(gameState(IsPowerOn, OxygenLevel, CurrentRoom, Inventory, Objects, ExplosiveTimer, _)),
	asserta(gameState(IsPowerOn, OxygenLevel, CurrentRoom, Inventory, Objects, ExplosiveTimer, Value)).	
	
get_isPowerOn(Value) :- gameState(Value, _, _, _, _, _, _).
get_oxygenLevel(Value) :- gameState(_, Value, _, _, _, _, _).
get_currentRoom(Value) :- gameState(_, _, Value, _, _, _, _).
get_inventory(Value) :- gameState(_, _, _, Value, _, _, _).
get_objects(Value) :- gameState(_, _, _, _, Value, _, _).
get_explosiveTimer(Value) :- gameState(_, _, _, _, _, Value, _).
get_distance(Value) :- gameState(_, _, _, _, _, _, Value).

gameState_load(Stream) :-
	read(Stream, GameState),
	asserta(GameState).

gameState_save(Stream) :-
	gameState(IsPowerOn, OxygenLevel, CurrentRoom, Inventory, Objects, ExplosiveTimer, Distance),
	write_term(Stream, gameState(IsPowerOn, OxygenLevel, CurrentRoom, Inventory, Objects, ExplosiveTimer, Distance), [quoted(true)]), write(Stream, .).

/* Initial game state */

init_gameState :-
	asserta(gameState(0, 10, 'Weapons room', [], [

		['barrels', 'Weapons room', 1],
		['explosives', 'Weapons room', 0],
		['weapons', 'Weapons room', 1],

		['sonar display', 'Sonar room', 1],
		['airlock inner hatch', 'Sonar room', 1],
		['headphones', 'Sonar room', 0],

		['airlock outer hatch', 'Airlock', 1],

		['book', 'Crew''s quarters', 0],
		['canned food', 'Crew''s quarters', 0],
		['bucket', 'Crew''s quarters', 0],
		['knife', 'Crew''s quarters', 0],
		['dying sailor','Crew''s quarters',0],

		['intelligence documents', 'Wardroom', 0],
		['ship''s log', 'Wardroom', 0],

		['diving equipment', 'Storage room', 0],
		['oxygen canister', 'Storage room', 0],
		['crowbar', 'Storage room', 0],

		['control panel', 'Control room', 1],
		['map', 'Control room', 0],
		['radio', 'Control room', 1],
		['periscope', 'Control room', 1],

		['fuse box', 'Engine room', 1],
		['reactor status display', 'Engine room', 1],
		['engine spare parts', 'Engine room', 0],
		['fire extinguisher', 'Engine room', 0],
		['oxygen canister', 'Engine room', 0],

		['hole', 'Reactor', 1],
		['engine', 'Reactor', 1],
		['dead engineer', 'Reactor', 1]

	], -1, 30)).

/* Constants */

maxOxygenLevel(10).
