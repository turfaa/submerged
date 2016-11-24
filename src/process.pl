process('exit') :- menuLoop, !.
process('quit') :- menuLoop, !.
process('menu') :- menuLoop, !.

process('n') :- go(n), !, fail.
process('e') :- go(e), !, fail.
process('s') :- go(s), !, fail.
process('w') :- go(w), !, fail.
process(_) :- write('Invalid command'), nl, !, fail.

/* Koneksi antar ruangan */

path('Weapons room', e, 'Sonar room').
path('Sonar room', w, 'Weapons room').

path('Sonar room', n, 'Airlock').
path('Airlock', s, 'Sonar room').

path('Sonar room', s, 'Crew\'s quarter').
path('Crew\'s quarter', n, 'Sonar room').

path('Sonar room', e, 'Control room').
path('Control room', w, 'Sonar room').

path('Crew\'s quarters', w, 'Wardroom').
path('Wardroom', e, 'Crew\'s quarter').

path('Crew\'s quarter', e, 'Storage room').
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