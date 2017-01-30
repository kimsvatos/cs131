

let rec createRules nonterminal gram1 = 
 	match gram1 with
 	| [] -> []
 	| (left, right)::t -> if left = nonterminal then
 	                     		right::(createRules left t)
 	                      else
 	                      		createRules left t 
;;

let convert_grammar gram1 = 
	match gram1 with 
	| (start, rules) -> (start, (createRules rules))
;;



(*Write a function parse_prefix gram that
 returns a matcher for the grammar gram. When applied 
to an acceptor accept and a fragment frag, the matcher 
must return the first acceptable match of a prefix of 
frag, by trying the grammar rules in order; this is not 
necessarily the shortest nor the longest acceptable
 match. A match is considered to be acceptable if 
accept succeeds when given a derivation and the suffix
 fragment that immediately follows the matching prefix. 
When this happens, the matcher returns whatever the acceptor
 returned. If no acceptable match is found, the matcher returns None.*)

(*returns a MATCHER for gram. try grammar rules in order. *)

(*  we have a grammar (start, gramm) and we want to 
	check if frag matches any start -> rule  *)

(* ruleList is a list of lists of rules ie
   | Term ->
	 [[N Num];
	  [N Lvalue];
	  [N Incrop; N Lvalue];
	  [N Lvalue; N Incrop];
	  [T"("; N Expr; T")"]]

h is the current [ N Num] we are seeing if can match frag
*)


(* start list is a list of list [[blah; blah] ; [blah] ; [blah; blah; blah] ]  
	rules func: term -> list of possibilities (tree)
	frag: literal string we parse
*)

type ('nonterminal, 'terminal) symbol =
  | N of 'nonterminal
  | T of 'terminal



let rec matchRuleTerm ruleFunc ruleSymbol acceptor frag deriv = 
	match ruleSymbol with
	[] -> acceptor deriv frag
	| _ -> match frag with 
			| [] -> None
			| (fragHead)::(fragTail) -> match ruleSymbol with 
				     	| (T termHead)::(termTail) -> if fragHead = termHead then 
				     								  	matchRuleTerm termTail ruleFunc acceptor fragTail deriv
				     								  else
				     									None
				     	(* ^^ terminal, so we can match the NEXT part of Frag*)
						| (N nonTermHead)::(nonTermTail) -> (matchRuleList ruleSymbol ruleFunc (matchRuleTerm nonTermTail ruleFunc acceptor frag deriv) frag deriv)
						(*non terminal, must expand with match ruleList*)




(* this is where we check arrowList ---- all possible things that symbol could lead to. 
eg. Expr -> term binop expr       // arrowList is "term binop expr"*)
and matchRuleList symbol ruleFunc acceptor frag deriv = 
(*let arrowList = ruleFunc symbol in *)
match (ruleFunc symbol) with
	(*if we've exhausted all possible rule groups, return None*)
	[] -> None
	(* h is the first possibility, but h can be a list itself. check this single rule, adding to deriv*)
	| h::t-> match (matchRuleTerm ruleFunc h acceptor frag deriv::[(symbol, h)]) with 
			| None -> (matchRuleTerm symbol ruleFunc t frag deriv)
			(* Try the next ruleGroup in arrowList as a possibility, which is t, since h is current ruleGroup
			    leave OUT this part int the deriv*)
			| Some(x, y) -> Some (x, y)
			(* we succeeded, return itself *)


let rec parse_prefix gram acceptor frag = 
	match gram with
	| (start, ruleFunc) -> matchRuleList start ruleFunc acceptor frag []







