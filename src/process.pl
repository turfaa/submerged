process('exit') :- menuLoop, !.
process('menu') :- menuLoop, !.
process('n') :- go(n), !, fail.
process('e') :- go(e), !, fail.
process('s') :- go(s), !, fail.
process('w') :- go(w), !, fail.
process(_) :- write('Invalid command'),nl, !, fail.

/* Koneksi antar ruangan */

path('Torpedo room', e, 'Sonar room').
path('Sonar room', w, 'Torpedo room').

path('Sonar room', n, 'Airlock').
path('Airlock', s, 'Sonar room').

path('Sonar room', s, 'Crew\'s quarter').
path('Crew\'s quarter', n, 'Sonar room').

path('Sonar room', e, 'Control room').
path('Control room', w, 'Sonar room').

path('Crew\'s quarter', w, 'Wardroom').
path('Wardroom', e, 'Crew\'s quarter').

path('Crew\'s quarter', e, 'Storage room').
path('Storage room', w, 'Crew\'s quarter').

path('Control room', e, 'Engine room').
path('Engine room', w, 'Control room').

path('Engine room', e, 'Reactor').
path('Reactor', w, 'Engine room').

path('Reactor', n, 'Surface').
path('Surface', s, 'Reactor').


go(Direction) :-
        get_gameState(IsPowerOn, OxygenLevel, CurrentRoom, Inventory),
        path(CurrentRoom, Direction, NextRoom),
		retract(gameState(IsPowerOn, OxygenLevel, CurrentRoom, Inventory)),
        set_gameState(IsPowerOn, OxygenLevel, NextRoom, Inventory).

go(_) :-
        write('You can''t go that way.'), nl.	