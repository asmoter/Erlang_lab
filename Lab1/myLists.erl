%%%-------------------------------------------------------------------
%%% @author Dell Latitude E7440
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. mar 2019 18:22
%%%-------------------------------------------------------------------
-module(myLists).
-author("Dell Latitude E7440").

%% API
-export([contains/2, duplicateElements/1, sumFloats/1, sumFloats2/2]).

% Zad.4
contains([Head | Tail], Value) ->
  if
    Head == Value -> true;
    Head /= Value -> contains(Tail, Value);
    true -> false
  end.

duplicateElements([]) -> [];
duplicateElements([Head | Tail]) -> ([Head, Head | duplicateElements(Tail)]).

sumFloats([]) -> 0;
sumFloats([Head | Tail]) ->
  case is_float(Head) of
    true -> Head + sumFloats(Tail);
    false -> sumFloats(Tail)
  end.

% Zad.5 z rekurencja ogonowa
sumFloats2([], Sum) -> Sum;
sumFloats2([Head | Tail], Sum) ->
  case is_float(Head) of
    true -> sumFloats2(Tail, Sum + Head);
    false -> sumFloats2(Tail, Sum)
  end.
