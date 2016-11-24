process('exit') :- menuLoop, !.
process('quit') :- menuLoop, !.
process('menu') :- menuLoop, !.

process('n') :- go(n), !, fail.
process('e') :- go(e), !, fail.
process('s') :- go(s), !, fail.
process('w') :- go(w), !, fail.

process(use(X)) :- use(X), !, fail.
process(take(Object)) :- take(Object), !, fail.
process(drop(Object)) :- drop(Object), !, fail.

process(_) :- write('Invalid command'), nl, !, fail.


/* Koneksi antar ruangan */

path('Weapons room', e, 'Sonar room') :- get_objects(Objects), member("barrels",Objects).

path('Sonar room', w, 'Weapons room') :- get_objects(Objects), member("barrels",Objects).
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
path('Engine room', e, 'Reactor') :- get_objects(Objects), member("crowbar",Objects).

path('Reactor', w, 'Engine room').
path('Reactor', n, 'Surface').

path(CurrentRoom, Direction, CurrentRoom) :- path_story(CurrentRoom, Direction).

path_story('Weapons room', e) :- write('It seems like there''s a way, but there are barrels covering it'), nl.
path_story('Sonar room', w) :- write('It seems like there''s a way, but there are barrels covering it'), nl.
path_story('Engine room', e) :- write('The hatch is too small'), nl.
path_story('Sonar room', n) :- write('The door is locked'), nl.
path_story('Airlock', s) :- write('It seems like there''s a way, but there are barrels covering it'), nl.

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


/* Fungsi pembantu */
max(X, Y, X) :- X > Y, !.
max(X, Y, Y).

min(X, Y, X) :- X < Y, !.
min(X, Y, Y).
