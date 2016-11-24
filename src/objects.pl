
get_objectName([Value, _, _], Value).
get_objectRoom([_, Value, _], Value).
get_objectIsStatic([_, _, Value], Value).

use(X) :- write(X, '\n').