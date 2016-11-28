process('exit') :- 
	retract(gameState(Value, OxygenLevel, CurrentRoom, Inventory, Objects, ExplosiveTimer)),
	menuLoop, !.
process('quit') :- menuLoop, !.
process('menu') :- menuLoop, !.

process('n') :- go(n), !, fail.
process('e') :- go(e), !, fail.
process('s') :- go(s), !, fail.
process('w') :- go(w), !, fail.

process('look') :- !, fail.

process(use(X)) :- use(X), !, fail.
process(take(Object)) :- take(Object), !, fail.
process(drop(Object)) :- drop(Object), !, fail.
process(interact(Object)) :- interact(Object), !, fail.
process(move) :- move, !, fail.

process('save') :- 
	open('gamestate.txt', write, Stream), 
	gameState_save(Stream), close(Stream),
	write('Game saved.'), nl, !, fail.

process(_) :- write('Invalid command.'), nl, !, fail.


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
path('Reactor', n, 'Surface').

path(CurrentRoom, Direction, CurrentRoom) :- path_story(CurrentRoom, Direction).

path_story('Weapons room', e) :- write('It seems like there''s a way, but there are barrels covering it.'), nl.
path_story('Sonar room', w) :- write('It seems like there''s a way, but there are barrels covering it.'), nl.
path_story('Engine room', e) :- write('The hatch is too small.'), nl.
path_story('Sonar room', n) :- write('The door is locked.'), nl.
path_story('Airlock', s) :- write('It seems like there''s a way, but there are barrels covering it.'), nl.

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

/* Fungsi pembantu */
max(X, Y, X) :- X > Y, !.
max(_, Y, Y).

min(X, Y, X) :- X < Y, !.
min(_, Y, Y).
