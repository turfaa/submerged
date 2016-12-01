render_gameState :- !,
	render_room, render_status.

render_room :-
	gameState(_, _, CurrentRoom, _, Objects, _, _, _, _, _),
	displayCurrentRoom(CurrentRoom),
	displayStoryRoom(CurrentRoom),
	displayObjects(Objects, CurrentRoom).

render_status :-
	gameState(IsPowerOn, OxygenLevel, _, Inventory, _, ExplosiveTimer, _, _, _, _),
	displayInventory(Inventory),
	displayOxygenLevel(OxygenLevel),
	displayIsPowerOn(IsPowerOn),
	displayExplosiveTimer(ExplosiveTimer).

displayCurrentRoom(CurrentRoom) :- write('You are in the '), write(CurrentRoom), write('.'), nl, nl.

displayStoryRoom('Weapons room') :- 
	write('You are in the weapons room, at the bow of the sub.'), nl,
	write('Only the faint red glow of the emergency fluorescent lighting remains.'), nl,
	write('The impact of the explosion has dislodged the stored weapons and barrels, which are now scattered on the floor.'), nl, nl.

displayStoryRoom('Sonar room') :-	
	write('You entered the sonar room.'), nl,
	write('There''s a ladder that leads to the airlock upwards, through a closed hatch.'), nl,
	write('Another closed hatch leads to the crew''s quarters below.'), nl,
	write('A passage opens to the control room in the back.'), nl, nl.

displayStoryRoom('Airlock') :-
	write('You opened the airlock inner hatch.'), nl,
	write('Streams of saltwater falls through; though not much.'), nl,
	write('The airlock chamber is wet.'), nl,
	write('Seawater is slowly leaking from the outer hatch above, which leads outside.'),
	write('There are the remains of used emergency survival equipment on the floor; the others must have already escaped through here.'), nl, nl.

displayStoryRoom('Crew''s quarters') :-	
	write('The crew''s quarters is where the crew rests when not on duty.'), nl,
	write('A hatch to the back connects it with the storage room; a door to the front connects it to the wardroom.'), nl,
	write('There''s a ladder to the sonar room above.'), nl, nl.

displayStoryRoom('Wardroom') :-
	write('The captain and senior officers are stationed in the wardroom.'), nl,
	write('Classified documents and manuals are usually kept here.'), nl,
	write('A door opens to the crew''s quarters behind.'), nl, nl.

displayStoryRoom('Storage room') :-
	write('Food, equipment and supplies are kept in the storage room.'), nl,
	write('A hatch connects it with the crew''s quarters in front.'), nl, nl.

displayStoryRoom('Control room') :-
	write('You entered the control room.'), nl,
	write('The sub''s computerized control and communication systems are mostly located here.'), nl,
	write('Various displays and gauges can be seen on the wall.'), nl,
	write('A console can be used to interact with the sub''s control AI.'), nl,
	write('A periscope mast is located near the center of the room.'), nl,
	write('A hatch opens to the back, to the engine room.'), nl,
	write('A passage leads forward to the sonar room.'), nl, nl.

displayStoryRoom('Engine room') :-	
	write('The engine room houses the forward part of the sub''s reactor and engines.'), nl,
	write('This room is where engineers control the sub''s power-generating reactors.'), nl, 
	write('A hatch leads to the control room in front.'), nl,
	write('Another hatch leads backwards, to the rear part of the reactor at the stern of the sub.'), nl, nl.

displayStoryRoom('Reactor') :-
	write('The reactor is flooded and heavily damaged.'), nl,
	write('It''s metal parts were torn apart.'), nl,
	write('The hull has been sliced through; a gaping hole opens to the outside. However, bent frames and metal pipes are blocking your way. You need to somehow clear the way by force to pass through and go outside.'), nl, nl.
	
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
