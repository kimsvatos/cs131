

type ('nonterminal, 'terminal) symbol =
	| N of 'nonterminal
	| T of 'terminal

let rec rule_list rules nt  = match rules with
	| [] -> []
	| h::t -> match h with 
		| lhs,rhs -> if(lhs = nt) then [rhs]@(rule_list t nt) else rule_list t nt

(*  currying function with missing params become function that takes the missing param(s) *)
let convert_grammar gram1 = match gram1 with
	| start, rules -> (start, (rule_list rules))

(* rhs is a single rule *)
(* check the current rhs and see if it matches with frag, by comparing terminals to terminals. If encounter a non-terminal, call check_alternative_list on that symbol *)
(* look into each symbol, if it is non-terminal, call check_alternative_list on list of rules starting with that symbol, call check_single_rule on rest of symbols and pass it as new acceptor *)
(* if it is terminal symbol, compare it to frag *)
let rec check_single_rule rule_list_func rhs accept d frag = 
	match rhs with 
	| [] -> accept d frag
	| _ -> match frag with 
		| [] -> None
		| h::t -> match rhs with 
			| (N n_ter) :: n_t -> (check_alternative_list n_ter rule_list_func (rule_list_func n_ter) (check_single_rule rule_list_func n_t accept) d frag)
			| (T ter) :: t_t -> if ter = h then (check_single_rule rule_list_func t_t accept d t) else None
	
(* start_symbol is the symbol that rules in alter_list start with *)
(* rule_list_func is the method that generates list of right-hand-sides for a nonterminal given *)
(* alter_list is list of rhs to check *)
(* the order could not be reversed, rules that come earlier should remain in front of list *)
and check_alternative_list start_symbol rule_list_func alter_list accept d frag = match alter_list with 
	| [] -> None
	| h::t -> match (check_single_rule rule_list_func h accept (d@[start_symbol,h]) frag) with 
		| None -> check_alternative_list start_symbol rule_list_func t accept d frag
		| Some(a,b) -> Some(a,b)

let parse_prefix gram accept frag = match gram with 
	| (start, rule_list_func) -> check_alternative_list start rule_list_func (rule_list_func start) accept [] frag