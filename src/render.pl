render_gameState :- !,
	render_room, render_status.

render_room :-
	gameState(_, _, CurrentRoom, _, Objects, _),
	displayCurrentRoom(CurrentRoom),
	displayStoryRoom(CurrentRoom),
	displayObjects(Objects, CurrentRoom).
	
render_status :-
	gameState(IsPowerOn, OxygenLevel, _, Inventory, _, ExplosiveTimer),
	displayInventory(Inventory),
	displayOxygenLevel(OxygenLevel),
	displayIsPowerOn(IsPowerOn),
	displayExplosiveTimer(ExplosiveTimer).
	
displayCurrentRoom(CurrentRoom) :- write('You are in the '), write(CurrentRoom), write('.'), nl, nl.

displayStoryRoom(_).

displayInventory(Inventory) :- length(Inventory, X), X > 0, !, write('You are carrying:'), nl, displayList(Inventory).

displayInventory([]) :- write('You are carrying nothing.'), nl, nl.

displayOxygenLevel(OxygenLevel) :-
	write('Oxygen level '),
	maxOxygenLevel(MaxOxygenLevel),
	displayMeter(OxygenLevel, MaxOxygenLevel),
	nl, nl.

displayIsPowerOn(IsPowerOn) :- IsPowerOn = 0, !, write('Ship''s power is off.'), nl, nl.
displayIsPowerOn(_) :- write('Ship''s power is on.'), nl, nl.

displayObjects(Objects, CurrentRoom) :- write('This room contains: '), nl, findall(ObjectsInRoom, member([ObjectsInRoom, CurrentRoom, _], Objects), L), displayList(L).

displayExplosiveTimer(ExplosiveTimer) :- \+ ExplosiveTimer = -1, write('The explosives will detonate in '), write(ExplosiveTimer), write(' second(s).'), nl, nl.
displayExplosiveTimer(_).

displayNChars(_, N) :- N =< 0.
displayNChars(Character, N) :- N > 0, write(Character), Next is N-1, displayNChars(Character, Next).

displayMeter(Value, MaxValue) :-
	write(Value), write('/'), write(MaxValue), write(' '),
	displayNChars('#', Value),
	Remaining is MaxValue - Value,
	displayNChars('.', Remaining).

/* Untuk menampilkan isi List */	
displayList([]) :- nl.
displayList([X|Y]) :-
	write(X), nl, displayList(Y).