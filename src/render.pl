render_gameState :- !,
	gameState(IsPowerOn, OxygenLevel, CurrentRoom, Inventory, Objects, ExplosiveTimer),
	displayCurrentRoom(CurrentRoom),
	displayStoryRoom(CurrentRoom),
	displayInventory(Inventory),
	displayOxygenLevel(OxygenLevel),
	displayIsPowerOn(IsPowerOn),
	displayObjects(Objects, CurrentRoom),
	displayExplosiveTimer(ExplosiveTimer).

displayCurrentRoom(CurrentRoom) :- write('You are in the '), write(CurrentRoom), write('.'), nl.

displayStoryRoom(_).

displayInventory(Inventory) :- length(Inventory, X), X > 0, !, write(Inventory), nl.

displayInventory([]) :- write('You are carrying nothing.'), nl.

displayOxygenLevel(OxygenLevel).

displayIsPowerOn(IsPowerOn) :- IsPowerOn = 0, !, write('Ship''s power is off.'), nl.
displayIsPowerOn(IsPowerOn) :- write('Ship''s power is on.').

displayObjects(Objects, CurrentRoom) :- write('This room contains '), findall(ObjectsInRoom, member([ObjectsInRoom, CurrentRoom, _], Objects), L), write(L), nl.

displayExplosiveTimer(ExplosiveTimer) :- \+ ExplosiveTimer = -1, write('Your ship will be exploded in '), write(ExplosiveTimer), write(' second(s).'), nl.
displayExplosiveTimer(ExplosiveTimer).
