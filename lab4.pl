:- [lab4_db].

filter_plant(QUERY_ILLNESS, [_, ILLNESSES]) :- member(QUERY_ILLNESS, ILLNESSES).
compare_object([NAME1, ILLNESSES1], [NAME2, _], [NAME1, ILLNESSES1]) :- NAME1 @=< NAME2, !.
compare_object([_, _], [NAME2, ILLNESSES2], [NAME2, ILLNESSES2]).

merge_lists([], [], _, []).
merge_lists([X | TAILX], [], _, [X | TAILX]).
merge_lists([], [Y | TAILY], _, [Y | TAILY]).
merge_lists([X | TAILX], [Y | TAILY], COMP, [X | RECURS]) :-  call(COMP, X, Y, X), !, merge_lists(TAILX, [Y | TAILY], COMP, RECURS).
merge_lists([X | TAILX], [Y | TAILY], COMP, [Y | RECURS]) :-  call(COMP, X, Y, Y), merge_lists([X | TAILX], TAILY, COMP, RECURS).

split_list([], _, [], []) :- !.
split_list(LIST, 0, [], LIST) :- !.
split_list([FIRST | TAIL], N, LEFT, RIGHT) :- N1 is N-1, split_list(TAIL, N1, LEFT_INTERNAL, RIGHT), LEFT = [FIRST | LEFT_INTERNAL].

sort_objects([], _, []).
sort_objects([A], _, [A]) :- !.
sort_objects(OBJECTS_LIST, COMP, RESULT) :- length(OBJECTS_LIST, N), MIDDLE is div(N, 2), split_list(OBJECTS_LIST, MIDDLE, LEFT, RIGHT), sort_objects(LEFT, COMP, SORTED_LEFT), sort_objects(RIGHT, COMP, SORTED_RIGHT), merge_lists(SORTED_LEFT, SORTED_RIGHT, COMP, RESULT).

find(ILLNESS, X) :- findall([NAME, ILLNESSES], plant(NAME, ILLNESSES), OBJECTS1), include(filter_plant(ILLNESS), OBJECTS1, OBJECTS), sort_objects(OBJECTS, compare_object, X). 

