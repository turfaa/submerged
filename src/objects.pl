get_objectName([Value, _, _], Value).
get_objectRoom([_, Value, _], Value).
get_objectIsStatic([_, _, Value], Value).

take(Object) :-
	get_currentRoom(CurrentRoom),
	get_objects(Objects),
	member([Object, CurrentRoom, 0], Objects),
	get_inventory(Inventory),
	length(Inventory, Size),
	Size == 3,
	write('Your inventory is full'), nl, nl,
	get_distance(OldDistance), NewDistance is OldDistance - 1, set_distance(NewDistance).

take(Object) :-
	get_currentRoom(CurrentRoom),
	get_objects(Objects),
	member([Object, CurrentRoom, 0], Objects),
	get_inventory(Inventory),
	append(Inventory, [Object], NewInventory),
	set_inventory(NewInventory),
	delete(Objects, [Object, CurrentRoom, 0], NewObjects),
	set_objects(NewObjects),
	write('You take '), write(Object), write('.'), nl, nl,
	get_distance(OldDistance), NewDistance is OldDistance - 1, set_distance(NewDistance).

take(Object) :-
	get_currentRoom(CurrentRoom),
	get_objects(Objects),
	member([Object, CurrentRoom, 1], Objects),
	write('You cannot take '), write(Object), write('.'), nl, nl,
	get_distance(OldDistance), NewDistance is OldDistance - 1, set_distance(NewDistance).

take(Object) :-
	get_inventory(Inventory),
	member(Object, Inventory),
	write('It''s already in your inventory.'), nl, nl,
	get_distance(OldDistance), NewDistance is OldDistance - 1, set_distance(NewDistance).

take(_) :-
	write('It''s not here'), nl, nl,
	get_distance(OldDistance), NewDistance is OldDistance - 1, set_distance(NewDistance).

drop(Object) :-
	get_inventory(Inventory),
	member(Object, Inventory),
	delete(Inventory, Object, NewInventory),
	set_inventory(NewInventory),
	get_currentRoom(CurrentRoom),
	get_objects(Objects),
	append(Objects, [[Object,CurrentRoom,0]], NewObjects),
	set_objects(NewObjects),
	write('You drop '), write(Object), write('.'), nl, nl,
	get_distance(OldDistance), NewDistance is OldDistance - 1, set_distance(NewDistance).

drop(_) :-
	write('It''s not in your inventory.'), nl, nl,
	get_distance(OldDistance), NewDistance is OldDistance - 1, set_distance(NewDistance).