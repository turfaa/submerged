render_gameState :-
	gameState(IsPowerOn, OxygenLevel, CurrentRoom, Inventory, Objects),
	displayCurrentRoom(CurrentRoom),
	displayInventory(Inventory),
	displayOxygenLevel(OxygenLevel),
	displayIsPowerOn(IsPowerOn),
	displayObjects(Objects).

displayCurrentRoom(CurrentRoom) :- write('You are in the '), write(CurrentRoom), write('.'), nl.

displayInventory(Inventory) :- length(Inventory, X), X > 0, !, write(Inventory), nl.
displayInventory([]) :- write('You are carrying nothing.'), nl.

displayOxygenLevel(OxygenLevel).

displayIsPowerOn(IsPowerOn).

displayObjects(Objects).
