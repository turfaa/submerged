:- include('gamestate.pl').
:- include('render.pl').
:- include('process.pl').

/* Main menu loop */

submerged :- menuLoop.

menuLoop :-
	nl,
	write('= SUBMERGED ='), nl,
	write('============='), nl,
	nl,
	repeat,
	catch((
		write('Enter [start.] to begin, [exit.] to quit:'), nl, write('> '),
		read(user_input, Input),
		menuAction(Input)
	), error(syntax_error(_), _), (
		write('Invalid input.'), nl, fail, !
	)).


menuAction('start') :-
	gameState_assign(0, 10, 'armory', [], GameState), /* set initial game state */
	gameLoop(GameState).
					   
menuAction('exit') :- abort.
menuAction('quit') :- abort.
menuAction(_) :- write('Invalid action.'), nl, !, fail.

/* Main game loop */

gameLoop(GameState) :-
	repeat,
	catch((

		/* Render game state */
		render(GameState), 

		/* Input */
		write('> '),
		read(user_input, Input),

		/* Process input */
		process(GameState, Input)

	), error(syntax_error(_), _), (
		write('Invalid input.'), nl, fail, !
	)).


