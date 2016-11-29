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
