/* Main menu loop */

:- initialization(submerged).
submerged :- menuLoop.

menuLoop :-
	nl,
	write('= SUBMERGED ='), nl,
	write('============='), nl,
	nl,
	repeat,
	catch((
		write('Enter [start.] to begin, [load(Filename).] to load game, [exit.] to quit:'), nl, write('> '),
		read(user_input, Input),
		menuAction(Input)
	), error(syntax_error(_), _), (
		write('Invalid input.'), nl, fail, !
	)).


menuAction('start') :-
	init_gameState, /* set initial game state */
	instructions,
	write('You wake up alone on the cold, hard metal floor of your sub''s weapons room.'), nl, 
	write('Your head still hurts from the impact of the explosion before.'), nl,
	write('You tried to slowly stand up, grabbing the pipes on the sides of the room.'), nl,
	write('Seawater is trickling down from leaks at the wall and pooling to the front.'), nl,
	write('Only then you realized that the sub is pointing at at angle downwards, and is probably still sinking deeper and deeper.'), nl,
	write('You know that you don''t have much time to escape to the surface.'), nl, nl,
	render_gameState,
	gameLoop.

menuAction(load(FileName)) :-
	loadGame(FileName),
	render_gameState,
	gameLoop.

menuAction('exit') :- abort.
menuAction('quit') :- abort.
menuAction(_) :- write('Invalid action.'), nl, !, fail.

/* Main game loop */

gameLoop :-
	repeat,
	catch((

		/* Input */
		write('> '),
		read(user_input, Input),

		/* Process input */
		process(Input),

		\+ win,
		\+ gameOver,

		fail

	), error(syntax_error(_), _), (
		write('Invalid input.'), nl, fail, !
	)).
