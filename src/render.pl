render_gameState :-
	gameState(IsPowerOn, OxygenLevel, CurrentRoom, Inventory, Objects),
	displayCurrentRoom(CurrentRoom),
	displayInventory(Inventory),
	displayOxygenLevel(OxygenLevel),
	displayIsPowerOn(IsPowerOn),
	displayObjects(Objects).

displayCurrentRoom(CurrentRoom) :- write('You are in the '), write(CurrentRoom), write('.'), nl.

displayInventory([Inventory]) :- write(Inventory), nl.
displayInventory([]) :- write('You are carrying nothing.'), nl.

displayOxygenLevel(OxygenLevel) :-
	write('Oxygen level '),
	maxOxygenLevel(MaxOxygenLevel),
	displayMeter(OxygenLevel, MaxOxygenLevel),
	nl.

displayIsPowerOn(IsPowerOn).

displayObjects(Objects).

displayNChars(Character, N) :- N =< 0.
displayNChars(Character, N) :- N > 0, write(Character), Next is N-1, displayNChars(Character, Next).

displayMeter(Value, MaxValue) :-
	write(Value), write('/'), write(MaxValue), write(' '),
	displayNChars('#', Value),
	Remaining is MaxValue - Value,
	displayNChars('.', Remaining).