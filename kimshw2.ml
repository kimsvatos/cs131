
let rec createRules nonterminal gram1 = 
 	match gram1 with
 	| [] -> []
 	| (left, right)::t -> if left = nonterminal then
 	                     		right::(createRules left t)
 	                      else
 	                      		createRules left t 


let convert_grammar gram1 = 
	match gram1 with 
	| (start, rules) -> (start, (createRules rules))


(* from hw 1 type defs *)

type ('nonterminal, 'terminal) symbol =
  | N of 'nonterminal
  | T of 'terminal



let rec matchRuleTerm ruleSymbol ruleFunc acceptor deriv frag= 
	(*match ruleSymbol with*)
	(*[] -> acceptor deriv frag*) 
	(* there are no rules left, check if acceptor is chill *)
(*	| _ ->*)match frag with 
			| [] -> None 
			(* ^^ we are at the end of the fragment, but have rules left. Cant work. None*)
			| (fragHead)::(fragTail) -> match ruleSymbol with 
					| [] -> acceptor deriv frag 
					| (N nonTermHead)::(nonTermTail) -> 
					(* if nonterminal, must expand this list how we did with Start, call matchRuleList*)
					(matchRuleList (nonTermHead) (ruleFunc) (ruleFunc nonTermHead) (matchRuleTerm ruleFunc nonTermTail acceptor) deriv frag)
				     | (T termHead)::(termTail) -> if fragHead = termHead then 
				     								  (matchRuleTerm termTail ruleFunc acceptor deriv fragTail) else None
				     (*if terminal, check that the fragment matches the term. If no, NONE try a diff one. 
				     	if YES, we attempt to keep matching rules, excluding this section of the frag,
				     	and moving on to the next term in the rules*)


(* arrowList is what a nonTerminal leads to, eg
Expr -> [term;binop;expr] ; [term]; [expr] 
the entire right part of the arrow is arrowList, we must check the next one 
if the first one fails and returns None
*)
and matchRuleList start ruleFunc arrowList accept deriv frag =
 match arrowList with 
	| [] -> None
	| h::t -> match (matchRuleTerm h ruleFunc accept (deriv@[start,h]) frag) with 
	(* try this combination, adding this start and chunk of arrowList to the deriv*)
		| Some(x,y) -> Some(x,y) 
		(* We're done! otherwise, try a diff possiblity of ArrowList*)
		| None -> matchRuleList start ruleFunc t accept deriv frag
		(* this failed--dont include this in the deriv, try the next chunk of arrowList as an attempt*)
		


let  parse_prefix gram acceptor frag = 
	match gram with
	| (start, ruleFunc) -> matchRuleList start ruleFunc (ruleFunc start) acceptor [] frag




