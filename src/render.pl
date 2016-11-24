render_gameState :-
	gameState(IsPowerOn, OxygenLevel, CurrentRoom, Inventory, Objects),
	displayCurrentRoom(CurrentRoom),
	displayStoryRoom(CurrentRoom),
	displayInventory(Inventory),
	displayOxygenLevel(OxygenLevel),
	displayIsPowerOn(IsPowerOn),
	displayObjects(Objects).

displayCurrentRoom(CurrentRoom) :- write('You are in the '), write(CurrentRoom), write('.'), nl.

displayStoryRoom(_).

displayInventory([]) :- write('You are carrying nothing.'), nl.

displayOxygenLevel(OxygenLevel).

displayIsPowerOn(IsPowerOn).

displayObjects(Objects).
