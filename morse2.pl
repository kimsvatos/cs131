
%	morse code %


is_valid([], []).
% 111 -> dah - 
% more than three '1'...cut off to be 3 ones, rerun
is_valid( [ 1, 1, 1, 1 | Tail], Morse):- is_valid([[1,1,1] | Tail], Morse).

% 3 '1's only 
is_valid([1,1,1 | Tail], ['-' | Morse]):- is_valid(Tail, Morse).

% 2 '1's only --> try '.' first, then '-'
is_valid([ 1,1 | Tail], ['.' | Morse]):- is_valid(Tail, Morse).
is_valid([1,1 | Tail], ['-' | Morse]):- is_valid(Tail, Morse).

% 1 '1's only --> '.'
is_valid([ 1 | Tail], ['.' | Morse]):- is_valid(Tail, Morse).

% 7+ '0's --> cut off to have 6 '0's, rerun
is_valid( [ 0,0,0,0,0,0,0 | Tail], Morse):- is_valid([ 0,0,0,0,0,0 | Tail], Morse).

%6 '0's --> automatically a #
is_valid( [ 0,0,0,0,0,0 | Tail], [ '#' | Morse]):- is_valid( Tail, Morse).

%5 '0's --> check 3 first (^), then 7 (#)
is_valid( [ 0,0,0,0,0 | Tail], [ '^' | Morse]):- is_valid( Tail, Morse).
is_valid( [ 0,0,0,0,0 | Tail], [ '#' | Morse]):- is_valid( Tail, Morse).

% 3 or 4 '0's -> must be ^
is_valid( [ 0,0,0,0 | Tail], [ '^' | Morse]):- is_valid( Tail, Morse).
is_valid( [ 0,0,0 | Tail], [ '^' | Morse]):- is_valid( Tail, Morse).

% 2 '0's -> try 1 first (nothing), then 3 (^)
is_valid( [ 0,0  | Tail],  Morse):- is_valid( Tail, Morse).
is_valid( [ 0,0  | Tail],  [ '^' | Morse]):- is_valid( Tail, Morse).

% 1 '0' -> nothing
is_valid( [ 0 | Tail],  Morse):- is_valid( Tail, Morse).



signal_morse([],[]).
signal_morse( Binary, M) :- is_valid(Binary, M).


morse(a, [.,-]).           % A
morse(b, [-,.,.,.]).	   % B
morse(c, [-,.,-,.]).	   % C
morse(d, [-,.,.]).	   % D
morse(e, [.]).		   % E
morse('e''', [.,.,-,.,.]). % É (accented E)
morse(f, [.,.,-,.]).	   % F
morse(g, [-,-,.]).	   % G
morse(h, [.,.,.,.]).	   % H
morse(i, [.,.]).	   % I
morse(j, [.,-,-,-]).	   % J
morse(k, [-,.,-]).	   % K or invitation to transmit
morse(l, [.,-,.,.]).	   % L
morse(m, [-,-]).	   % M
morse(n, [-,.]).	   % N
morse(o, [-,-,-]).	   % O
morse(p, [.,-,-,.]).	   % P
morse(q, [-,-,.,-]).	   % Q
morse(r, [.,-,.]).	   % R
morse(s, [.,.,.]).	   % S
morse(t, [-]).	 	   % T
morse(u, [.,.,-]).	   % U
morse(v, [.,.,.,-]).	   % V
morse(w, [.,-,-]).	   % W
morse(x, [-,.,.,-]).	   % X or multiplication sign
morse(y, [-,.,-,-]).	   % Y
morse(z, [-,-,.,.]).	   % Z
morse(0, [-,-,-,-,-]).	   % 0
morse(1, [.,-,-,-,-]).	   % 1
morse(2, [.,.,-,-,-]).	   % 2
morse(3, [.,.,.,-,-]).	   % 3
morse(4, [.,.,.,.,-]).	   % 4
morse(5, [.,.,.,.,.]).	   % 5
morse(6, [-,.,.,.,.]).	   % 6
morse(7, [-,-,.,.,.]).	   % 7
morse(8, [-,-,-,.,.]).	   % 8
morse(9, [-,-,-,-,.]).	   % 9
morse(., [.,-,.,-,.,-]).   % . (period)
morse(',', [-,-,.,.,-,-]). % , (comma)
morse(:, [-,-,-,.,.,.]).   % : (colon or division sign)
morse(?, [.,.,-,-,.,.]).   % ? (question mark)
morse('''',[.,-,-,-,-,.]). % ' (apostrophe)
morse(-, [-,.,.,.,.,-]).   % - (hyphen or dash or subtraction sign)
morse(/, [-,.,.,-,.]).     % / (fraction bar or division sign)
morse('(', [-,.,-,-,.]).   % ( (left-hand bracket or parenthesis)
morse(')', [-,.,-,-,.,-]). % ) (right-hand bracket or parenthesis)
morse('"', [.,-,.,.,-,.]). % " (inverted commas or quotation marks)
morse(=, [-,.,.,.,-]).     % = (double hyphen)
morse(+, [.,-,.,-,.]).     % + (cross or addition sign)
morse(@, [.,-,-,.,-,.]).   % @ (commercial at)

% Error.
morse(error, [.,.,.,.,.,.,.,.]). % error - see below

% Prosigns.
morse(as, [.,-,.,.,.]).          % AS (wait A Second)
morse(ct, [-,.,-,.,-]).          % CT (starting signal, Copy This)
morse(sk, [.,.,.,-,.,-]).        % SK (end of work, Silent Key)
morse(sn, [.,.,.,-,.]).          % SN (understood, Sho' 'Nuff)

% build(Morse, word_being_built, final_message) %
%empty morse list cases
build([],[],[]).
build([], MorseWord, [English]) :- morse(English, MorseWord).

% '#' first in morse list cases
build(['#'| Tail], [], ['#' | Tail2 ]):- build(Tail, [], Tail2).
build(['#'| Tail], MorseWord, ['#' | Tail2 ]):- build(Tail, [], Tail2).

% '^' first in morse list
build(['^'| Tail], [], English):- build(Tail, [], English).
build(['^'| Tail], MorseWord, [Head2 | Tail2 ]):- morse(Head2, MorseWord), build(Tail, [], Tail2).

%other cases
build([Head | Tail], MorseWord, English):- append(MorseWord, [Head], X), build(Tail, X, English).

% english with errors and #,  collector , new approved english 
remove_errors([],[],[]).
remove_errors([], X, X).
remove_errors(['#'| OTail],[],['#' | NTail]):- remove_errors(Otail, [], NTail).
remove_errors(['#'| OTail],[ CollHead | CollTail ],[ CollHead | MessTail]):- 
		 remove_errors(['#' | OTail], CollTail, MessTail).
remove_errors([error, Next | Tail], Collected, Message):-  =(error, Next),
		 append(Collected, [error], X), remove_errors( [Next | Tail], X, Message);
		 remove_errors([Next | Tail], [], Message).

remove_errors([Head | Tail], Collected, Message):- 
	\=([Head], ['error']),  append(Collected, [Head], X), remove_errors(Tail, X, Message).

% check for errors
errorcheck(Old, New):- remove_errors(Old, [], New).


signal_message([],[]).
signal_message(Binary, English):- signal_morse(Binary, Morse), build(Morse, [], Draft), errorcheck(Draft, English).






















