:- include('gamestate.pl').
:- include('render.pl').
:- include('process.pl').
:- include('objects.pl').

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
		write('Enter [start.] to begin, [load.] to load game, [exit.] to quit:'), nl, write('> '),
		read(user_input, Input),
		menuAction(Input)
	), error(syntax_error(_), _), (
		write('Invalid input.'), nl, fail, !
	)).


menuAction('start') :-
	init_gameState, /* set initial game state */
	gameLoop.

menuAction(loadGame(FileName)) :-
	loadGame(FileName),
	gameLoop.
	
menuAction('exit') :- abort.
menuAction('quit') :- abort.
menuAction(_) :- write('Invalid action.'), nl, !, fail.

/* Main game loop */

gameLoop :-
	repeat,
	catch((

		/* Render game state */
		render_gameState, 

		/* Input */
		write('> '),
		read(user_input, Input),

		/* Process input */
		process(Input),
		
		\+ gameOver,
		\+ win,
		
		fail

	), error(syntax_error(_), _), (
		write('Invalid input.'), nl, fail, !
	)).