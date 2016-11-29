process('exit') :-
	retract(gameState(_, _, _, _, _, _, _, _, _, _)),
	menuLoop, !.
process('quit') :-
	retract(gameState(_, _, _, _, _, _, _, _, _, _)),
	menuLoop, !.
process('menu') :- menuLoop, !.

process('n') :- go(n), !.
process('e') :- go(e), !.
process('s') :- go(s), !.
process('w') :- go(w), !.

process('look') :- render_room, !.
process('stat') :- render_status, !.

process('instructions') :- instructions, !.

process(talk(X)) :- talk(X), !.
process(use(X)) :- use(X), !.
process(take(Object)) :- take(Object), !.
process(drop(Object)) :- drop(Object), !.
process(move(Object)) :- move(Object), !.
process(suicide) :- suicide, !.
process(check) :- check, !.

process(switch(Object)) :- switch(Object), !.
process(operate(Object)) :- operate(Object), !.

process(save(FileName)) :- save(FileName), !.

process(_) :- write('Invalid command.'), nl, nl, !.

/* Instructions */
instructions :-
	write('Available commands are:'), nl,
	write('n, s, e, w.         -- to go in that direction.'), nl,
	write('take(Object).       -- to pick up an object'), nl,
	write('drop(Object).       -- to put down an object'), nl,
	write('use(Object).        -- to use an object'), nl,
	write('move(Object).       -- to move an object.'), nl,
	write('switch(Object).     -- to switch on/off switch.'), nl,
	write('operate(Object).    -- to operate an object.'), nl,
	write('check,              -- to check some status display.'),nl,
	write('suicide.            -- to commit suicide.'), nl,
	write('talk(Object/NPC).   -- to talk to an npc.'), nl,
	write('stat.               -- to see current status and inventory.'), nl,
	write('look.               -- to look around in your current room.'), nl,
	write('instructions.       -- to see this message again.'), nl,
	write('save(Filename).     -- to save current game.'), nl,
	write('quit.               -- to end the game and go back to main menu.'), nl, nl.

/* Koneksi antar ruangan */

path('Weapons room', e, 'Sonar room') :- get_objects(Objects), \+ member(['barrels', 'Weapons room', 1],Objects), !.
path('Sonar room', w, 'Weapons room') :- !.
path('Sonar room', n, 'Airlock') :- get_airlockLocked(IsLocked), IsLocked == 0, !.
path('Sonar room', s, 'Crew\'s quarters') :- !.
path('Sonar room', e, 'Control room') :- !.

path('Airlock', s, 'Sonar room') :- get_isPowerOn(Power), Power = 1, !.

path('Crew\'s quarters', n, 'Sonar room') :- !.
path('Crew\'s quarters', w, 'Wardroom') :- !.
path('Crew\'s quarters', e, 'Storage room') :- !.

path('Wardroom', e, 'Crew\'s quarters') :- !.

path('Storage room', w, 'Crew\'s quarters') :- !.

path('Control room', w, 'Sonar room') :- !.
path('Control room', e, 'Engine room') :- !.

path('Engine room', w, 'Control room') :- !.
path('Engine room', e, 'Reactor') :- get_reactorLocked(IsLocked), IsLocked == 0, !, set_flooded(1), nl, flooding.

path('Reactor', w, 'Engine room') :- !.
path('Reactor', n, 'Surface'):- get_objects(Objects), \+ member(['hole','Reactor', 1],Objects), !.

path(CurrentRoom, Direction, CurrentRoom) :- path_story(CurrentRoom, Direction).

path_story('Weapons room', e) :- write('It seems like there''s a way, but there are barrels covering it.'), nl, nl.
path_story('Sonar room', n) :- write('The hatch is locked.'), nl, nl.
path_story('Reactor', n) :- write('There''s a hole, but it''s too small for you to pass through.'), nl, nl.
path_story('Engine room', e) :- write('The room is locked.'), nl, nl.

go(Direction) :- get_currentRoom(CurrentRoom),
                 path(CurrentRoom, Direction, NextRoom),
                 CurrentRoom == NextRoom, !.

go(Direction) :- get_currentRoom(CurrentRoom),
                path(CurrentRoom, Direction, NextRoom),
				\+ CurrentRoom == NextRoom,
				\+ NextRoom == 'Surface',
                get_oxygenLevel(OldOxygen), NewOxygen is OldOxygen - 1, set_oxygenLevel(NewOxygen),
                set_currentRoom(NextRoom),
				get_explosiveTimer(OldExplosiveTimer),
				NewExplosiveTimer is OldExplosiveTimer - 1,
				max(-1, NewExplosiveTimer, ExplosiveTimer), set_explosiveTimer(ExplosiveTimer),
				get_distance(OldDistance), NewDistance is OldDistance - 1, set_distance(NewDistance),
				render_gameState, !.

go(Direction) :- get_currentRoom(CurrentRoom),
                path(CurrentRoom, Direction, NextRoom),
				set_currentRoom(NextRoom).				
				
go(_) :- write('You can''t go that way.'), nl, nl.

/* Use Inventory */
use(Barang) :- get_inventory(Inventory), \+ member(Barang, Inventory), !, write('You have no '), write(Barang), nl, nl,
	get_distance(OldDistance), NewDistance is OldDistance - 1, set_distance(NewDistance).

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
								set_inventory(NewInventory),
								get_distance(OldDistance), NewDistance is OldDistance - 1, set_distance(NewDistance).

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
								set_inventory(NewInventory),
								get_distance(OldDistance), NewDistance is OldDistance - 1, set_distance(NewDistance).

use(explosives)		:- 	get_distance(OldDistance), NewDistance is OldDistance - 1, set_distance(NewDistance),
							write('Enter the arming code: '),
							read(user_input, Input), Input = 'PANDORA BOX', !,
							write('You activate the explosives.'), set_explosiveTimer(20), nl, nl,
                            get_inventory(Inventory),
                            delete(Inventory, 'explosives', NewInventory),
                            set_inventory(NewInventory).

use(explosives)		:- !, write('Wrong arming code.'), nl, nl, get_distance(OldDistance), NewDistance is OldDistance - 1, set_distance(NewDistance).

use('intelligence documents')   :- !, write('The arming code is : ''PANDORA BOX'' (with quotes)'), nl,
                                      use('Use it wisely.'), nl, nl, get_distance(OldDistance), NewDistance is OldDistance - 1, set_distance(NewDistance).

use(crowbar) :-
	get_currentRoom(CurrentRoom),
	get_objects(Objects),
	delete(Objects, ['hole', CurrentRoom, 1], NewObjects),
	set_objects(NewObjects),
	write('You use the crowbar to widen the hole.'), nl, nl,
	get_distance(OldDistance), NewDistance is OldDistance - 1, set_distance(NewDistance).

use(map) :-
	write('                 Airlock                                        '), nl,
	write('                    |                                           '), nl,
	write('                    |                                           '), nl,
	write('Weapons room - Sonar room - Control room - Engine room - Reactor'), nl,
	write('                    |                                           '), nl,
	write('                    |                                           '), nl,
	write('Wardroom - Crew''s quarters - Storage room                      '), nl, nl,
	write('<< Forward  Backward >>                                         '), nl, nl,
	get_distance(OldDistance), NewDistance is OldDistance - 1, set_distance(NewDistance).

use('diving equipment') :-
	write('You wear the diving equipment.'), nl, nl,
	get_inventory(Inventory), 
	delete(Inventory, 'diving equipment', NewInventory),
	set_inventory(NewInventory).

use(Object) :-
	write('There''s no use of this '), write(Object), write(' yet.'), nl,nl,
	get_distance(OldDistance), NewDistance is OldDistance - 1, set_distance(NewDistance).

/* Memindahkan Barrel*/
move(Object) :-
		get_currentRoom(CurrentRoom),
        get_objects(Objects),
        \+ member([Object, CurrentRoom, _], Objects),
        !,
        write('There''s no '),
		write(Object), write(' here'), nl, nl,
		get_distance(OldDistance), NewDistance is OldDistance - 1, set_distance(NewDistance).

move(barrels) :-
		get_currentRoom(CurrentRoom),
        get_objects(Objects),
        delete(Objects, ['barrels', CurrentRoom, 1], NewObjects),
        set_objects(NewObjects),
        write('You successfully moved the barrels.'), nl, nl,
		get_distance(OldDistance), NewDistance is OldDistance - 1, set_distance(NewDistance).

move(Object) :-
		write('You cannot move '), write(Object), write('.'), nl, nl,
		get_distance(OldDistance), NewDistance is OldDistance - 1, set_distance(NewDistance).

/* Radio : Mendapatkan informasi tentang secondary objective */
talk(Object) :-
		get_currentRoom(CurrentRoom),
        get_objects(Objects),
        \+ member([Object, CurrentRoom, _], Objects),
        !,
        write('There''s no '),
		write(Object), write(' here'), nl, nl,
		get_distance(OldDistance), NewDistance is OldDistance - 1, set_distance(NewDistance).

talk(radio) :-
		get_currentRoom(CurrentRoom),
		get_isPowerOn(Power),
		Power = 0,
		get_objects(Objects), member(['radio', CurrentRoom, 1], Objects),
		!,
		write('You found a radio, but there''s no power.'), nl, nl,
		get_distance(OldDistance), NewDistance is OldDistance - 1, set_distance(NewDistance).

talk(radio) :-
		get_currentRoom(CurrentRoom),
		get_isPowerOn(Power),
		Power = 1,
		get_objects(Objects), member(['radio', CurrentRoom, 1], Objects),
		\+ member(['dying sailor',_,_], Objects),
		!,
		write('You enter the radio''s password'), nl,
		write('Your secondary objective is destroy this submarine'), nl, nl,
		get_distance(OldDistance), NewDistance is OldDistance - 1, set_distance(NewDistance).

talk(radio) :-
		get_currentRoom(CurrentRoom),
		get_isPowerOn(Power),
		Power = 1,
		get_objects(Objects), member(['radio', CurrentRoom, 1], Objects),
		!,
		write('You found a radio, but it''s password protected'), nl, nl,
		get_distance(OldDistance), NewDistance is OldDistance - 1, set_distance(NewDistance).

talk('dying sailor') :-
		get_currentRoom(CurrentRoom),
		get_objects(Objects), member(['dying sailor', CurrentRoom, 0], Objects),
		!,
		write('Please do something for me, hear the radio. This is the password'), nl,
		write('The sailor died'), nl, nl,
		delete(Objects, ['dying sailor', CurrentRoom, 0], NewObjects), set_objects(NewObjects),
		get_distance(OldDistance), NewDistance is OldDistance - 1, set_distance(NewDistance).

talk(Object) :-
		write('You cannot talk to '), write(Object), write('.'), nl, nl,
		get_distance(OldDistance), NewDistance is OldDistance - 1, set_distance(NewDistance).

/* Ketika hidup sudah mulai keras, saatnya untuk putus asa dan mengakhiri semua ini */
suicide :-
	get_inventory(Inventory), member('knife', Inventory),
	!,
	write('You are about to suicide, do you really wanna do that?'), nl,
	write('NB : It''s hurt so much and against god rules'), nl,
	write('(yes/no)?'), nl,
	read(user_input, Input), Input = 'yes',
	!,
	write('You choose to be dead.'), nl,
	write('We are dissapointed.'), nl, nl,
	write('Game Over'), nl, nl,
	retract(gameState(_, _, _, _, _, _, _, _, _, _)),
	menuLoop, !.

/* Reactor status display */
check :-
	get_currentRoom(CurrentRoom),
	CurrentRoom == 'Engine room',
	write('The reactor room is flooded. You could die if you open the door.'), nl, nl,
	!.

/* Airlock outer hatch */
check :-	
	get_currentRoom(CurrentRoom),
	CurrentRoom == 'Airlock',
	write('The hatch is jammed.'), nl, nl,
	!.
	
/* Switch fuse box */

switch(Object) :-
	get_currentRoom(CurrentRoom),
	get_objects(Objects),
	\+ member([Object, CurrentRoom, _], Objects),
	!,
	write('There''s no '),
	write(Object), write(' here.'), nl, nl,
	get_distance(OldDistance), NewDistance is OldDistance - 1, set_distance(NewDistance).

switch('fuse box') :-
	get_isPowerOn(IsPowerOn),
	IsPowerOn = 0,
	set_isPowerOn(1),
	write('You turn on the power.'),
	nl, nl,
	get_distance(OldDistance), NewDistance is OldDistance - 1, set_distance(NewDistance).

switch('fuse box') :-
	get_isPowerOn(IsPowerOn),
	IsPowerOn = 1,
	set_isPowerOn(0),
	write('You turn off the power.'),
	nl, nl,
	get_distance(OldDistance), NewDistance is OldDistance - 1, set_distance(NewDistance).

switch(Object) :-
	write('You cannot switch '),
	write(Object), write('.'), nl, nl,
	nl, nl,
	get_distance(OldDistance), NewDistance is OldDistance - 1, set_distance(NewDistance).

switch(Object) :-
	write('You cannot switch '),
	write(Object), write('.'), nl, nl,
	get_distance(OldDistance), NewDistance is OldDistance - 1, set_distance(NewDistance).

/* Operate */
operate(Object) :-
	get_currentRoom(CurrentRoom),
	get_objects(Objects),
	\+ member([Object, CurrentRoom, _], Objects),
	!,
	write('There''s no '),
	write(Object), write(' here.'), nl, nl,
	get_distance(OldDistance), NewDistance is OldDistance - 1, set_distance(NewDistance).

operate('sonar display') :-
	get_isPowerOn(IsPowerOn),
	IsPowerOn = 0,
	write('There''s no power.'),
	nl, nl,
	get_distance(OldDistance), NewDistance is OldDistance - 1, set_distance(NewDistance).

operate('sonar display') :-
	get_isPowerOn(IsPowerOn),
	IsPowerOn = 1,
	get_distance(Distance),
	write('Distance with enemy''s sub is '), write(Distance), write('.'), nl,
	write('It''s getting closer.'), nl, nl,
	get_distance(OldDistance), NewDistance is OldDistance - 1, set_distance(NewDistance).

operate('control panel') :-
	get_isPowerOn(IsPowerOn),
	IsPowerOn = 0,
	write('There''s no power.'),
	nl, nl,
	get_distance(OldDistance), NewDistance is OldDistance - 1, set_distance(NewDistance).

operate('control panel') :-
	get_isPowerOn(IsPowerOn),
	IsPowerOn = 1,
    get_airlockLocked(Airlock),
    get_reactorLocked(Reactor),
    Airlock == 1,
    Reactor == 1,
	write('You unlock all hatches.'), nl, nl,
	get_distance(OldDistance), NewDistance is OldDistance - 1, set_distance(NewDistance),
    set_airlockLocked(0),
    set_reactorLocked(0).

operate('control panel') :-
	get_isPowerOn(IsPowerOn),
	IsPowerOn = 1,
    get_airlockLocked(Airlock),
    get_reactorLocked(Reactor),
    Airlock == 0,
    Reactor == 0,
	write('You lock all hatches.'), nl, nl,
	get_distance(OldDistance), NewDistance is OldDistance - 1, set_distance(NewDistance),
    get_distance(OldDistance), NewDistance is OldDistance - 1, set_distance(NewDistance),
    set_airlockLocked(1),
    set_reactorLocked(1).

operate(Object) :-
	write('You cannot operate '),
	write(Object), write('.'), nl, nl,
	get_distance(OldDistance), NewDistance is OldDistance - 1, set_distance(NewDistance).

flooding :-
    get_inventory(Inventory),
    get_objects(Objects),
    \+ member('diving equipment', Inventory),
    \+ member(['diving equipment', _, _], Objects), !.

flooding :-
    write('Your submarine is flooded, and you can''t go out of it.'), nl,
    write('Use your diving equipment next time. (If you are reincarnated, of course)'), nl,
    write('Game Over'), nl, nl,
    retract(gameState(_, _, _, _, _, _, _, _, _, _)),
    menuLoop, !.

/* Save and Load */
save(FileName) :-
	open(FileName, write, Stream),
	gameState_save(Stream), close(Stream),
	write('Game saved.'), nl, nl.

loadGame(FileName) :-
	open(FileName, read, Stream),
	gameState_load(Stream),
	close(Stream),
	write('Game loaded.'), nl, nl.

/* Game Over */
gameOver :-
	get_oxygenLevel(Oxygen),
	Oxygen = 0,
	write('You ran out of oxygen.'), nl,
	write('You are starting to lose your consciousness.'), nl, nl,
	write('Game Over'), nl, nl,
	retract(gameState(_, _, _, _, _, _, _, _, _, _)),
	menuLoop, !.

gameOver :-
	get_explosiveTimer(ExplosiveTimer),
	ExplosiveTimer = 0,
	write('The explosives exploded.'), nl,
	write('You died.'), nl, nl,
	write('Game Over'), nl, nl,
	retract(gameState(_, _, _, _, _, _, _, _, _, _)),
	menuLoop, !.

gameOver :-
	get_distance(Distance),
	Distance = 0,
	write('The enemy''s sub attacks this submarine.'), nl,
	write('You died.'), nl, nl,
	write('Game Over'), nl, nl,
	retract(gameState(_, _, _, _, _, _, _, _, _, _)),
	menuLoop, !.


/* Win */
win :-
	get_currentRoom(CurrentRoom),
	CurrentRoom = 'Surface',
	write('Congratulations!! You finally reach the surface.'), nl, 
	render_status,
	get_explosiveTimer(ExplosiveTimer),
	ExplosiveTimer >= 0,
	write('Secondary objective - destroy submarine completed.'), nl, nl,
	retract(gameState(_, _, _, _, _, _, _, _, _, _)),
	credit,
	menuLoop, !.

win :-
	get_currentRoom(CurrentRoom),
	CurrentRoom = 'Surface',
	write('Congratulations!! You finally reach the surface.'), nl, 
	render_status,
	get_explosiveTimer(ExplosiveTimer),
	ExplosiveTimer == -1,
	write('You didn''t do the secondary objective'), nl, nl,
	retract(gameState(_, _, _, _, _, _, _, _, _, _)),
	credit,
	menuLoop, !.	

credit :-
	write('This game was created by:'), nl,
	write('> Jonathan Christopher / 13515001'), nl,
	write('> Jordhy Fernando / 13515004'), nl,
	write('> Jauhar Arifin / 13515049'), nl,
	write('> Turfa Auliarachman / 13515133'), nl, nl.
	
/* Fungsi pembantu */
max(X, Y, X) :- X > Y, !.
max(_, Y, Y).

min(X, Y, X) :- X < Y, !.
min(_, Y, Y).