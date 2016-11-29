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
process(activate(Object)) :- activate(Object), !.

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
				get_distance(OldDistance), NewDistance is OldDistance - 15, set_distance(NewDistance),
				render_gameState, !.

go(Direction) :- get_currentRoom(CurrentRoom),
                path(CurrentRoom, Direction, NextRoom),
				set_currentRoom(NextRoom).

go(_) :- write('You can''t go that way.'), nl, nl.

/* Use Inventory */
use(Barang) :- get_inventory(Inventory), \+ member(Barang, Inventory), !, write('You have no '), write(Barang), nl, nl,
	get_distance(OldDistance), NewDistance is OldDistance - 15, set_distance(NewDistance).

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
								get_distance(OldDistance), NewDistance is OldDistance - 15, set_distance(NewDistance).

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
								get_distance(OldDistance), NewDistance is OldDistance - 15, set_distance(NewDistance).

use(explosives)		:- 	get_distance(OldDistance), NewDistance is OldDistance - 15, set_distance(NewDistance),
							write('Enter the arming code: '),
							read(user_input, Input), Input = 524323, !,
							write('You activate the explosives.'), set_explosiveTimer(20), nl, nl,
                            get_inventory(Inventory),
                            delete(Inventory, 'explosives', NewInventory),
                            set_inventory(NewInventory).

use(explosives)		:- !, write('Wrong arming code.'), nl, nl, get_distance(OldDistance), NewDistance is OldDistance - 15, set_distance(NewDistance).

use('document 1') :-
	write('[ NSV Glasgow Technical Specifications ]'), nl, nl,
	write('Type: Edinburgh-class attack submarine'), nl,
	write('Power plant: 1x fission reactor'), nl,
	write('Length: 81 metres'), nl,
	write('Maximum depth: 800 metres'), nl,
	write('Maximum speed: 33 knots surfaced, 28 knots submerged'), nl,
	write('Crew: 20'), nl,
	write('Armament: 4x forward torpedo tubes, 4x missile tubes'), nl,
	write('Control system: AI, semi-autonomous - automatic damage control'), nl,
	write('[ End of document ]'), nl, nl,
	get_distance(OldDistance), NewDistance is OldDistance - 15, set_distance(NewDistance).

use('document 2')   :-
	write('[ Protocol concerning vessel self-destruction ]'), nl,
	write('In an emergency situation, the captain of the vessel may order the crew to abandon vessel.'), nl,
	write('In this event, the crew must ensure the destruction of the vessel after their evacuation to prevent classified information and technology from being salvaged by the enemy; especially if the vessel is carrying classified documents or equipment.'), nl,
	write('For this purpose, explosive charges have been installed at the bow of the ship.'), nl,
	write('A security code is required to arm the timed fuzes on these charges.'), nl,
	write('The security code for NSV Glasgow''s self-destruction explosives is 524323.'), nl,
	write('This information must be kept secure at all times.'), nl,
	write('Only the captain and the senior officer may have access to this document to prevent sabotage.'), nl,
	write('[ End of document ]'), nl, nl,
	get_distance(OldDistance), NewDistance is OldDistance - 15, set_distance(NewDistance).

use('document 3') :-
	write('[ Memo on #008 - Canterbury Active Defense System ]'), nl,
	write('NSV Glasgow has been fitted with a prototype active defense system, codename Canterbury.'), nl,
	write('Although it has not yet been thoroughly field-tested, High Command insisted that this system be fitted as soon as possible due to the high risk of an impending conflict.'), nl,
	write('This AI-controlled energy-based defense system is able to automatically detect and neutralize threats in a 100 metre radius around the ship. The exact workings are highly classified.'), nl,
	write('As this system emits a significant amount of easily detectable electromagnetic pulses, it is advisable to only activate this system when the sub is already detected by the enemy and is under attack.'), nl,
	write('It''s control system is directly linked to the sub''s control AI.'), nl,
	write('Only the captain may authorize its use; the activation code is 293441.'), nl,
	write('[ End of document ]'), nl, nl,
	get_distance(OldDistance), NewDistance is OldDistance - 15, set_distance(NewDistance).

use('sub''s log') :-
	write('[ NSV Glasgow -- Logs ]'), nl,
	write('[ November 3rd, 2022 - 10:00 ]'), nl,
	write('Received transmission from High Command updating alertness status to 1.'), nl,
	write('Orders are to head back and prepare for the impending conflict.'), nl,
	write('Changed course towards Port Arthur naval base.'), nl, nl,
	write('[ November 5th, 2022 - 15:27 ]'), nl,
	write('Arrived to Port Arthur naval base for resupply.'), nl,
	write('Restocked food, ammunition and other supplies.'), nl,
	write('Fitted with classified payload #008 [Excalibur Active Defense System].'), nl,
	write('Repaired minor damage to outer deck caused by events in entry #35410.'), nl, nl,
	write('[ November 17th, 2022 - 00:02 ]'), nl,
	write('Departed from Port Arthur naval base with the 1st Expeditionary Fleet''s ships.'), nl,
	write('Activated payload #008 once in deep waters; preliminary tests successful.'), nl, nl,
	write('[ November 17th, 2022 - 07:00 ]'), nl,
	write('Split up with the 1st Home Fleet ships.'), nl, nl,
	write('[ November 18th, 2022 - 10:21 ]'), nl,
	write('Rendezvous with NSV Canterbury at target area. Starting patrols.'), nl, nl,
	write('[ November 18th, 2022 - 23:47 ]'), nl,
	write('Detected the enemy''s 2nd Expeditionary Fleet at extreme range heading towards border.'), nl,
	write('Entered silent running mode.'), nl,
	write('Activated #008 [Excalibur].'), nl, nl,
	write('[ November 19th, 2022 - 01:57 ]'), nl,
	write('Detected by unknown enemy ASW destroyer, engaged with depth charges.'), nl,
	write('Slight damage to outer hull.'), nl,
	write('#008 [Excalibur] successfully intercepted 3 incoming attacks.'), nl,
	write('NSV Canterbury fired 4 torpedoes at enemy battleship Orion, target moderately damaged.'), nl, nl,
	write('[ November 19th, 2022 - 02:12 ]'), nl,
	write('Fired 6 torpedoes at enemy battleship Arcturus, target heavily damaged.'), nl,
	write('Tracked by at least 3 enemy ships. Taking evasive action.'), nl,
	write('#008 [Excalibur] successfully intercepted 8 incoming attacks.'), nl, nl,
	write('[ November 19th, 2022 - 02:37 ]'), nl,
	write('Detected anomalous electromagnetic field levels near enemy cruiser Vega.'), nl,
	write('#008 [Excalibur] intercepted 5 attacks, but failed to intercept 1. Moderate damage to bow section.'), nl, nl,
	write('[ November 19th, 2022 - 02:40 ]'), nl,
	write('Enemy cruiser Vega emitted powerful energy burst.'), nl,
	write('Stern section hit and heavily damaged and flooded.'), nl,
	write('Reactor heavily damaged and losing power.'), nl,
	write('Sub''s hull integrity compromised.'), nl,
	write('Activating damage control systems.'), nl, nl,
	write('[ November 19th, 2022 - 02:42 ]'), nl,
	write('Flooded compartments successfully sealed and locked, but sub is still sinking.'), nl,
	write('Failed to seal forward compartments.'), nl,
	write('Captain gave orders to abandon sub.'), nl,
	write('Crew evacuated sub through airlock using emergency equipment; two crew members missing and presumed dead.'), nl, nl,
	write('[ November 19th, 2022 - 02:45 ]'), nl,
	write('Forward section hit, Reactor overloaded.'), nl,
	write('Failover to backup batteries failed.'), nl,
	write('System about to lose power completely; initiating shutdown.'), nl,
	write('[ End of logs ]'), nl, nl,
	get_distance(OldDistance), NewDistance is OldDistance - 15, set_distance(NewDistance).

use(crowbar) :-
	get_currentRoom(CurrentRoom),
	get_objects(Objects),
	delete(Objects, ['hole', CurrentRoom, 1], NewObjects),
	set_objects(NewObjects),
	write('You use the crowbar to widen the hole.'), nl, nl,
	get_distance(OldDistance), NewDistance is OldDistance - 15, set_distance(NewDistance).

use(map) :-
	write('                 Airlock                                 Surface'), nl,
	write('                    |                                       |'), nl,
	write('                    |                                       |'), nl,
	write('Weapons room - Sonar room - Control room - Engine room - Reactor'), nl,
	write('                    |'), nl,
	write('                    |'), nl,
	write('Wardroom - Crew''s quarters - Storage room'), nl, nl,
	write('<< Forward  Backward >>'), nl, nl,
	get_distance(OldDistance), NewDistance is OldDistance - 15, set_distance(NewDistance).

use('diving equipment') :-
	write('You wear the diving equipment.'), nl, nl,
	get_inventory(Inventory),
	delete(Inventory, 'diving equipment', NewInventory),
	set_inventory(NewInventory).

use(Object) :-
	write('There''s no use of this '), write(Object), write(' yet.'), nl,nl,
	get_distance(OldDistance), NewDistance is OldDistance - 15, set_distance(NewDistance).

/* Memindahkan Barrel*/
move(Object) :-
		get_currentRoom(CurrentRoom),
        get_objects(Objects),
        \+ member([Object, CurrentRoom, _], Objects),
        !,
        write('There''s no '),
		write(Object), write(' here'), nl, nl,
		get_distance(OldDistance), NewDistance is OldDistance - 15, set_distance(NewDistance).

move(barrels) :-
		get_currentRoom(CurrentRoom),
        get_objects(Objects),
        delete(Objects, ['barrels', CurrentRoom, 1], NewObjects),
        set_objects(NewObjects),
        write('You successfully moved the barrels.'), nl, nl,
		get_distance(OldDistance), NewDistance is OldDistance - 15, set_distance(NewDistance).

move(Object) :-
		write('You cannot move '), write(Object), write('.'), nl, nl,
		get_distance(OldDistance), NewDistance is OldDistance - 15, set_distance(NewDistance).

/* Radio : Mendapatkan informasi tentang secondary objective */
talk(Object) :-
		get_currentRoom(CurrentRoom),
        get_objects(Objects),
        \+ member([Object, CurrentRoom, _], Objects),
        !,
        write('There''s no '),
		write(Object), write(' here'), nl, nl,
		get_distance(OldDistance), NewDistance is OldDistance - 15, set_distance(NewDistance).

talk(radio) :-
		get_currentRoom(CurrentRoom),
		get_isPowerOn(Power),
		Power = 0,
		get_objects(Objects), member(['radio', CurrentRoom, 1], Objects),
		!,
		write('You found a radio, but there''s no power.'), nl, nl,
		get_distance(OldDistance), NewDistance is OldDistance - 15, set_distance(NewDistance).

talk(radio) :-
		get_currentRoom(CurrentRoom),
		get_isPowerOn(Power),
		Power = 1,
		get_objects(Objects), member(['radio', CurrentRoom, 1], Objects),
		\+ member(['dying sailor',_,_], Objects),
		!,
		write('You enter the radio''s password'), nl,
		write('Your secondary objective is destroy this submarine'), nl, nl,
		get_distance(OldDistance), NewDistance is OldDistance - 15, set_distance(NewDistance).

talk(radio) :-
		get_currentRoom(CurrentRoom),
		get_isPowerOn(Power),
		Power = 1,
		get_objects(Objects), member(['radio', CurrentRoom, 1], Objects),
		!,
		write('You found a radio, but it''s password protected'), nl, nl,
		get_distance(OldDistance), NewDistance is OldDistance - 15, set_distance(NewDistance).

talk('dying sailor') :-
		get_currentRoom(CurrentRoom),
		get_objects(Objects), member(['dying sailor', CurrentRoom, 0], Objects),
		!,
		write('Please do something for me, hear the radio. This is the password'), nl,
		write('The sailor died'), nl, nl,
		delete(Objects, ['dying sailor', CurrentRoom, 0], NewObjects), set_objects(NewObjects),
		get_distance(OldDistance), NewDistance is OldDistance - 15, set_distance(NewDistance).

talk('Ship control AI') :-
	get_currentRoom(CurrentRoom),
	get_objects(Objects), member(['Ship control AI',CurrentRoom,1], Objects),
	!,
	write('Hello, I''m Aria. I can controll defense system of this ship'), nl.

talk(Object) :-
		write('You cannot talk to '), write(Object), write('.'), nl, nl,
		get_distance(OldDistance), NewDistance is OldDistance - 15, set_distance(NewDistance).

/* Terkadang diantara kesulitan hidup, kemudahan selalu datang dalam bentuk perlindungan terhadap kapal */
activate('Ship control AI') :-
	get_currentRoom(CurrentRoom),
	get_objects(Objects),
	member(['Ship control AI',CurrentRoom,1], Objects),
	member(['ai_defense_activated','untouched',0], Objects),
	write('You''re about to activate defense system.'), nl,
	write('The defense system is password protected.'), nl,
	write('Please enter the password: '),
	read(user_input, Input), Input = '293441',
	!,
	write('AI Defense System Activated'), nl,
	write('Now you don''t need to worry about enemies'), nl,
	delete(Objects, ['ai_defense_activated','untouched',0], NewObjects),
	set_objects(NewObjects).

activate('Ship control AI') :-
	get_currentRoom(CurrentRoom),
	get_objects(Objects),
	member(['Ship control AI',CurrentRoom,1], Objects),
	member(['ai_defense_activated','untouched',0], Objects),
	!,
	write('Wrong password!'), nl.

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
	get_distance(OldDistance), NewDistance is OldDistance - 15, set_distance(NewDistance).

switch('fuse box') :-
	get_isPowerOn(IsPowerOn),
	IsPowerOn = 0,
	set_isPowerOn(1),
	write('You turn on the power.'),
	nl, nl,
	get_distance(OldDistance), NewDistance is OldDistance - 15, set_distance(NewDistance).

switch('fuse box') :-
	get_isPowerOn(IsPowerOn),
	IsPowerOn = 1,
	set_isPowerOn(0),
	write('You turn off the power.'),
	nl, nl,
	get_distance(OldDistance), NewDistance is OldDistance - 15, set_distance(NewDistance).

switch(Object) :-
	write('You cannot switch '),
	write(Object), write('.'), nl, nl,
	nl, nl,
	get_distance(OldDistance), NewDistance is OldDistance - 15, set_distance(NewDistance).

switch(Object) :-
	write('You cannot switch '),
	write(Object), write('.'), nl, nl,
	get_distance(OldDistance), NewDistance is OldDistance - 15, set_distance(NewDistance).

/* Operate */
operate(Object) :-
	get_currentRoom(CurrentRoom),
	get_objects(Objects),
	\+ member([Object, CurrentRoom, _], Objects),
	!,
	write('There''s no '),
	write(Object), write(' here.'), nl, nl,
	get_distance(OldDistance), NewDistance is OldDistance - 15, set_distance(NewDistance).

operate('sonar display') :-
	get_isPowerOn(IsPowerOn),
	IsPowerOn = 0,
	write('There''s no power.'),
	nl, nl,
	get_distance(OldDistance), NewDistance is OldDistance - 15, set_distance(NewDistance).

operate('sonar display') :-
	get_isPowerOn(IsPowerOn),
	IsPowerOn = 1,
	get_distance(Distance),
	write('Distance with enemy''s sub is '), write(Distance), write('.'), nl,
	write('It''s getting closer.'), nl, nl,
	get_distance(OldDistance), NewDistance is OldDistance - 15, set_distance(NewDistance).

operate('control panel') :-
	get_isPowerOn(IsPowerOn),
	IsPowerOn = 0,
	write('There''s no power.'),
	nl, nl,
	get_distance(OldDistance), NewDistance is OldDistance - 15, set_distance(NewDistance).

operate('control panel') :-
	get_isPowerOn(IsPowerOn),
	IsPowerOn = 1,
    get_airlockLocked(Airlock),
    get_reactorLocked(Reactor),
    Airlock == 1,
    Reactor == 1,
	write('You unlock all hatches.'), nl, nl,
	get_distance(OldDistance), NewDistance is OldDistance - 15, set_distance(NewDistance),
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
	get_distance(OldDistance), NewDistance is OldDistance - 15, set_distance(NewDistance),
    get_distance(OldDistance), NewDistance is OldDistance - 15, set_distance(NewDistance),
    set_airlockLocked(1),
    set_reactorLocked(1).

operate(Object) :-
	write('You cannot operate '),
	write(Object), write('.'), nl, nl,
	get_distance(OldDistance), NewDistance is OldDistance - 15, set_distance(NewDistance).

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
	get_objects(Objects),
	member(['ai_defense_activated','untouched',0], Objects),
	get_distance(Distance),
	Distance =< 300,
	write('The enemy''s sub attacks this submarine.'), nl,
	write('You died.'), nl, nl,
	write('Game Over'), nl, nl,
	retract(gameState(_, _, _, _, _, _, _, _, _, _)),
	menuLoop, !.


/* Win */
win :-
	get_currentRoom(CurrentRoom),
	CurrentRoom = 'Surface',
	winmessage,
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
	winmessage,
	render_status,
	get_explosiveTimer(ExplosiveTimer),
	ExplosiveTimer == -1,
	write('You didn''t do the secondary objective'), nl, nl,
	retract(gameState(_, _, _, _, _, _, _, _, _, _)),
	credit,
	menuLoop, !.

winmessage :-
	write('You finally escaped from the doomed sub, and ascend slowly to the surface in your emergency diving equipment.'), nl,
	write('You reach the surface.'), nl,
	write('The sky is clear, and moonlight reflected off the somewhat calm sea, dotted with specks of oil and floating debris from the destroyed vessels.'), nl,
	write('In the distance, you see enemy ships sailing past the border.'), nl,
	write('The war has just started.'), nl, nl.


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
