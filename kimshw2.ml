

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
	| _ -> match frag with 
			| [] -> None
			| (fragHead)::(fragTail) -> match ruleSymbol with 
						| (N nonTermHead)::(nonTermTail) -> 
						(matchRuleList (nonTermHead) (ruleFunc) (ruleFunc nonTermHead) (matchRuleTerm ruleFunc nonTermTail acceptor) deriv frag)
				     	| (T termHead)::(termTail) -> (if fragHead = termHead then 
				     								  	(matchRuleTerm ruleFunc termTail acceptor deriv fragTail)
				     								  else
				     									None)
				     
				     	(* ^^ terminal, so we can match the NEXT part of Frag*)
						
						(*non terminal, must expand with match ruleList*)




(* this is where we check arrowList ---- all possible things that symbol could lead to. 
eg. Expr -> term binop expr       // arrowList is "term binop expr"*)
(*and matchRuleList symbol ruleFunc arrowList acceptor frag deriv = 
match arrowList with
	[] -> None
	(* h is the first possibility, but h can be a list itself. check this single rule, adding to deriv*)
	| h::t-> match (matchRuleTerm ruleFunc h acceptor frag (deriv@[symbol, h])) with 
			| None -> (matchRuleList symbol ruleFunc t frag deriv)
			(* Try the next ruleGroup in arrowList as a possibility, which is t, since h is current ruleGroup
			    leave OUT this part int the deriv*)
			| Some(x, y) -> Some (x, y)
			(* we succeeded, return itself *)*)

and matchRuleList start_symbol rule_list_func alter_list accept deriv frag = match alter_list with 
	| [] -> None
	| h::t -> match (check_single_rule rule_list_func h accept (deriv@[start_symbol,h]) frag) with 
		| None -> check_alternative_list start_symbol rule_list_func t accept deriv frag
		| Some(a,b) -> Some(a,b)


let  parse_prefix gram acceptor frag = 
	match gram with
	| (start, ruleFunc) -> matchRuleList start ruleFunc (ruleFunc start) acceptor [] frag







