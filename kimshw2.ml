

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




(* start list is a list of list [[blah; blah] ; [blah] ; [blah; blah; blah] ]  
	rules func: term -> list of possibilities (tree)
	frag: literal string we parse
*)

type ('nonterminal, 'terminal) symbol =
  | N of 'nonterminal
  | T of 'terminal



let rec matchRuleTerm ruleFunc ruleSymbol acceptor deriv frag= 
	match ruleSymbol with
	[] -> acceptor deriv frag
	| headRule::tailRule -> match headRule with
						| (T term) -> (
								match frag with 
								| [] -> None
								| headFrag::tailFrag -> if headFrag = headRule then 
														matchRuleTerm ruleFunc tailRule acceptor deriv tailFrag
													    else None
							) 
						| (N nonterm) -> (
						  matchRuleList headRule ruleFunc (ruleFunc headRule) acceptor deriv frag)




(*
			| [] -> None
			| (fragHead)::(fragTail) -> match fragHead with 
					| (N nonTermHead)::(nonTermTail) -> 
					(matchRuleList (nonTermHead) (ruleFunc) (ruleFunc nonTermHead) (matchRuleTerm ruleFunc nonTermTail acceptor) deriv frag)
				     | (T termHead)::(termTail) -> if fragHead = termHead then 
				     								  (matchRuleTerm ruleFunc termTail acceptor deriv fragTail) else None
*)

and matchRuleList start ruleFunc arrowList accept deriv frag =
 match arrowList with 
	| [] -> None
	| h::t -> match (matchRuleTerm ruleFunc h accept (deriv@[start,h]) frag) with 
		| None -> matchRuleList start ruleFunc t accept deriv frag
		| Some(a,b) -> Some(a,b)


let  parse_prefix gram acceptor frag = 
	match gram with
	| (start, ruleFunc) -> matchRuleList start ruleFunc (ruleFunc start) acceptor [] frag




