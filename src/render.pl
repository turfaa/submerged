render_gameState :-
	gameState(IsPowerOn, OxygenLevel, CurrentRoom, Inventory, Objects, ExplosiveTimer),
	displayCurrentRoom(CurrentRoom),
	displayInventory(Inventory),
	displayOxygenLevel(OxygenLevel),
	displayIsPowerOn(IsPowerOn),
	displayObjects(Objects),
	displayExplosiveTimer(ExplosiveTimer).

displayCurrentRoom(CurrentRoom) :- write('You are in the '), write(CurrentRoom), write('.'), nl.

displayInventory(Inventory) :- length(Inventory, X), X > 0, !, write(Inventory), nl.
displayInventory([]) :- write('You are carrying nothing.'), nl.

displayOxygenLevel(OxygenLevel).

displayIsPowerOn(IsPowerOn).

displayObjects(Objects).

displayExplosiveTimer(ExplosiveTimer) :- \+ ExplosiveTimer = 1, !, write('Your ship will be exploded in '), write(ExplosiveTimer), write(' second(s).'), nl.