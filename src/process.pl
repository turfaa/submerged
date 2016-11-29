process('exit') :- 
	retract(gameState(_, _, _, _, _, _)),
	menuLoop, !.
process('quit') :- menuLoop, !.
process('menu') :- menuLoop, !.

process('n') :- go(n), !.
process('e') :- go(e), !.
process('s') :- go(s), !.
process('w') :- go(w), !.

process('look') :- render_room, !.
process('stat') :- render_status, !.

process(use(X)) :- use(X), !.
process(take(Object)) :- take(Object), !.
process(drop(Object)) :- drop(Object), !.
process(interact(Object)) :- interact(Object), !.
process(move) :- move, !.

process(saveGame(FileName)) :- saveGame(FileName), !.

process(_) :- write('Invalid command.'), nl, !.


/* Koneksi antar ruangan */

path('Weapons room', e, 'Sonar room') :- get_objects(Objects), \+ member(['barrels', 'Weapons room', 1],Objects).
path('Sonar room', w, 'Weapons room').
path('Sonar room', n, 'Airlock') :- get_isPowerOn(Power), Power = 1.
path('Sonar room', s, 'Crew\'s quarters').
path('Sonar room', e, 'Control room').

path('Airlock', s, 'Sonar room') :- get_isPowerOn(Power), Power = 1.

path('Crew\'s quarters', n, 'Sonar room').
path('Crew\'s quarters', w, 'Wardroom').
path('Crew\'s quarters', e, 'Storage room').

path('Wardroom', e, 'Crew\'s quarters').

path('Storage room', w, 'Crew\'s quarters').

path('Control room', w, 'Sonar room').
path('Control room', e, 'Engine room').

path('Engine room', w, 'Control room').
path('Engine room', e, 'Reactor').

path('Reactor', w, 'Engine room').
path('Reactor', n, 'Surface'):- get_objects(Objects), \+ member(['hole','Reactor', 1],Objects).

path(CurrentRoom, Direction, CurrentRoom) :- path_story(CurrentRoom, Direction).

path_story('Weapons room', e) :- write('It seems like there''s a way, but there are barrels covering it.'), nl.
path_story('Sonar room', w) :- write('It seems like there''s a way, but there are barrels covering it.'), nl.
path_story('Engine room', e) :- write('The hatch is too small.'), nl.
path_story('Sonar room', n) :- write('The door is locked.'), nl.
path_story('Airlock', s) :- write('It seems like there''s a way, but there are barrels covering it.'), nl.
path_story('Reactor', n) :- write('There''s a hole, but it''s too small for you to pass through.'), nl.

go(Direction) :- get_currentRoom(CurrentRoom),
                path(CurrentRoom, Direction, NextRoom),
                get_oxygenLevel(OldOxygen), NewOxygen is OldOxygen - 1, set_oxygenLevel(NewOxygen),
                set_currentRoom(NextRoom).

go(_) :- write('You can''t go that way.'), nl.


/* Use Inventory */
use(Barang) :- get_inventory(Inventory), \+ member(Barang, Inventory), !, write('You have no '), write(Barang), write('\n').

use('fire extinguisher') :- !, get_oxygenLevel(Init),
								Nxt is Init-3,
								set_oxygenLevel(Nxt),
								write('You use the fire extinguisher.'),
								nl,
								write('Your Oxygen Level is now '),
								write(Nxt),
								write('. (evillaugh)'),
								nl, nl,
								get_inventory(Inventory),
								delete(Inventory, 'fire extinguisher', NewInventory),
								set_inventory(NewInventory).

use('oxygen canister') :- !, get_oxygenLevel(Init),
								Tr is Init+5,
								min(Tr, 10, Nxt),
								set_oxygenLevel(Nxt),
								write('You use the oxygen canister.'),
								nl,
								write('Your Oxygen Level is now '),
								write(Nxt),
								nl, nl,
								get_inventory(Inventory),
								delete(Inventory, 'oxygen canister', NewInventory),
								set_inventory(NewInventory).

use('explosives')		:- write('Enter the arming code: '),
							read(user_input, Input), Input = 'PANDORA BOX', !,
							write('You activate the explosives.'), set_explosiveTimer(20), nl,
                            get_inventory(Inventory),
                            delete(Inventory, 'explosives', NewInventory),
                            set_inventory(NewInventory).

use('explosives')		:- !, write('Wrong arming code.').

use('intelligence documents')   :- !, write('The arming code is : ''PANDORA BOX'' (with quotes)'), nl,
                                      use('Use it wisely.'), nl.
									  
use('crowbar') :- 
	get_currentRoom(CurrentRoom),
	get_objects(Objects),
	\+ member(['hole', CurrentRoom, 1], Objects),
	write('There''s no hole here.'), nl.
	
use('crowbar') :- 
	get_currentRoom(CurrentRoom),
	get_objects(Objects),
	delete(Objects, ['hole', CurrentRoom, 1], NewObjects),
	set_objects(NewObjects),
	write('You use the crowbar to widen the hole.'), nl.
	
									  
/* Memindahkan Barrel*/
move :- get_currentRoom(CurrentRoom),
        get_objects(Objects),
        \+ member(['barrels', CurrentRoom, 1], Objects),
        !,
        write('There''s no barrel here.'), nl.

move :- get_currentRoom(CurrentRoom),
        get_objects(Objects),
        delete(Objects, ['barrels', CurrentRoom, 1], NewObjects),
        set_objects(NewObjects),
        write('Successfully moved the barrels.'), nl.

/* Save and Load */
saveGame(FileName) :-
	open(FileName, write, Stream), 
	gameState_save(Stream), close(Stream),
	write('Game saved.'), nl, nl.

loadGame(FileName) :-
	open(FileName, read, Stream),
	gameState_load(Stream),
	close(Stream),
	write('Game loaded'), nl, nl.
	
/* Game Over */
gameOver :-
	get_oxygenLevel(Oxygen), 
	Oxygen = 0, 
	write('You ran out of oxygen.'), nl,
	write('You are starting to lose your consciousness.'), nl, nl,
	write('Game Over'), nl, nl, 
	retract(gameState(_, _, _, _, _, _)),
	menuLoop, !.

/* Win */
win :-
	get_currentRoom(CurrentRoom),
	CurrentRoom = 'Surface',
	retract(gameState(_, _, _, _, _, _)),
	menuLoop, !.
	
/* Fungsi pembantu */
max(X, Y, X) :- X > Y, !.
max(_, Y, Y).

min(X, Y, X) :- X < Y, !.
min(_, Y, Y).
