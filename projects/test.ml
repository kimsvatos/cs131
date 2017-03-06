(* part one: convert grammar from hw1 to hw2 *)

(* start, [Expr, [N Term; N Binop; N Expr];
  Term, [N Num];
  Term, [T '3'];
  Num, [T "3"];
  Binop, [T "+"];
  Expr, [N Term];
  Term, [N Num];
  Num, [T "4"]]
)

(* let awkish_grammar =   hw2
  (Expr,
   function
     | Expr ->
         [[N Term; N Binop; N Expr];
          [N Term]]
     | Term ->
	 [[N Num];
	  [N Lvalue];
	  [N Incrop; N Lvalue];
	  [N Lvalue; N Incrop];
	  [T"("; N Expr; T")"]]
     | Lvalue ->
	 [[T"$"; N Expr]]
     | Incrop ->
	 [[T"++"];
	  [T"--"]]
     | Binop ->
	 [[T"+"];
	  [T"-"]]
     | Num ->
	 [[T"0"]; [T"1"]; [T"2"]; [T"3"]; [T"4"];
	  [T"5"]; [T"6"]; [T"7"]; [T"8"]; [T"9"]]) *)
)
*)
 (*
  *  takes (symbol, list) -> (symbol, production function)
  *)

(* 
*  createrules goes through all of gram1 and adds to list if 
*  matches nonterm
*
*)

type ('a, 'b) symbol = N of 'a | T of 'b


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
	| (start, rules) -> (start, (fun x -> createRules x rules))
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
let rec genMatcher g =
	match g with 
	| [] -> (fun a -> fun frag -> a [] frag)
    | 
    (* next case: not empty*)



let rec parse_prefix gram = 




















