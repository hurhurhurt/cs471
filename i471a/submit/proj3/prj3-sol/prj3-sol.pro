sum_tree(leaf(V), Sum) :-
  Sum is V.
sum_tree(tree(T1, V, T2), Sum) :-
  sum_tree(T1, Sum1),
  sum_tree(T2, Sum2),
  Sum is V + Sum1 + Sum2.
  
naive_flatten_tree(nil, []).
naive_flatten_tree(leaf(L), Flattened) :-
  Flattened = [L|[]].
naive_flatten_tree(tree(T1, V, T2), Flattened) :-
  naive_flatten_tree(T1, V1),
  naive_flatten_tree(T2, V2),
  append(V1, [V|V2], Flattened).

flatten_tree(Tree, Flattened) :-
  flatten_helper(Tree, [], Flattened).
flatten_helper(tree(T1, V, T2), Accum, Reversed) :-
  flatten_helper(T2, Accum, Rest),
  flatten_helper(T1, [V | Rest], Reversed).
flatten_helper(leaf(L), Accum, Rest) :-
  Rest = [L | Accum].  

parse_arith(List, Final, Value) :-
  term(List, Final, Value).

parse_arith(List, Final, ValueSum) :-
  term(List, ['+'|First], Value1),
  parse_arith(First, Final, Value2),
  plus(Value1, Value2, ValueSum).

term(List, Final, Value) :-
  factor(List, Final, Value).

term(List, Final, ValueMul) :-
  factor(List, ['*'|First], Value1),
  term(First, Final, Value2),
  ValueMul is Value1 * Value2.

factor([Value|Final], Final, Value) :-
  integer(Value).

factor(['('|List], Final, Value) :-
  parse_arith(List, [')'|Final], Value).

wiki_nfa(nfa(x, [ x - 0 - x, x - 1 - x, x - 1 - a,
  a - 0 - b, a - 1 - b,
  b - 0 - c, b - 1 - c,
  c - 0 - d, c - 1 - d
  ], [d])).
  
nfa_sim(nfa(S, Transitions, Final), [I | Rest], States) :-
  member(S - I - X, Transitions),
  nfa_sim(nfa(X, Transitions, Final), Rest, Future),
  States = [S | Future].

nfa_sim(nfa(S, _, Final), [], [S]) :-
  member(S, Final).
