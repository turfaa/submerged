render_gameState :-
	get_gameState(IsPowerOn, OxygenLevel, CurrentRoom, Inventory),
	displayCurrentRoom(CurrentRoom),
	displayInventory(Inventory),
	displayOxygenLevel(OxygenLevel),
	displayIsPowerOn(IsPowerOn).

displayCurrentRoom(CurrentRoom) :- write('You are in the '), write(CurrentRoom), write('.'), nl.

displayInventory([]) :- write('You are carrying nothing.'), nl.

displayOxygenLevel(OxygenLevel).

displayIsPowerOn(IsPowerOn).
