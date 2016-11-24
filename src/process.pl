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

path('Weapons room', e, 'Sonar room').
path('Sonar room', w, 'Weapons room').

path('Sonar room', n, 'Airlock').
path('Airlock', s, 'Sonar room').

path('Sonar room', s, 'Crew\'s quarters').
path('Crew\'s quarters', n, 'Sonar room').

path('Sonar room', e, 'Control room').
path('Control room', w, 'Sonar room').

path('Crew\'s quarters', w, 'Wardroom').
path('Wardroom', e, 'Crew\'s quarters').

path('Crew\'s quarters', e, 'Storage room').
path('Storage room', w, 'Crew\'s quarters').

path('Control room', e, 'Engine room').
path('Engine room', w, 'Control room').

path('Engine room', e, 'Reactor').
path('Reactor', w, 'Engine room').

path('Reactor', n, 'Surface').
path('Surface', s, 'Reactor').

go(Direction) :- get_currentRoom(CurrentRoom), path(CurrentRoom, Direction, NextRoom), set_currentRoom(NextRoom).

go(_) :-
	write('You can''t go that way.'), nl.	


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