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
