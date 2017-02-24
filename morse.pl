%%%%%% part 1 %%%%%

% Empty list, always true %
to_morse([], []).

% one term
to_morse([H], [[1, H]]). 

to_morse( [ H | T ], [[C,H] | Remaining ]) :- to_morse(T, [[SC, H] | Remaining]), succ(SC, C), !. 

to_morse( [ H | T ], [[1,H] | [SC, X] | Remaining]) :- to_morse(T, [[SC, X] | Remaining]), H \= X, !. 


% 0 cases
% one or two zeros, ignore
is_correct([[1,0] | Remaining], ['.' | MorseEncoded]):- is_correct( Remaining, MorseEncoded).
is_correct([[2,0] | Remaining], ['.' | MorseEncoded]):- is_correct( Remaining, MorseEncoded).
is_correct([[X,0] | Remaining], ['^' | MorseEncoded]):- X>1, X<6, is_correct(Remaining, MorseEncoded).
is_correct([[X,0] | Remaining], ['#' | MorseEncoded]):- X>4, is_correct(Remaining, MorseEncoded).

% 1 cases
is_correct([], []).
% 1.... '.' %
is_correct( [[1,1] | Remaining], ['.' | MorseEncoded]):- is_correct(Remaining, MorseEncoded).
% 11 -> try '.' first %
is_correct( [[2,1] | Remaining], ['.' | MorseEncoded]):- is_correct(Remaining, MorseEncoded).
% 11 -> try '-'
is_correct( [[2,1] | Remaining], ['-' | MorseEncoded]):- is_correct(Remaining, MorseEncoded).
% 111 or more -> '-' 
is_correct( [[X,1], | Remaining], ['-' | MorseEncoded]):- X > 2, is_correct(Remaining, MorseEncoded).

signal_morse([], []).
signal_morse([H|T], Res):- to_morse([H|T], Encoded), is_correct(Enconded, Res).