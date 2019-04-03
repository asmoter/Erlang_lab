%%%-------------------------------------------------------------------
%%% @author Dell Latitude E7440
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. mar 2019 09:50
%%%-------------------------------------------------------------------
-module(qsort).

%% API

-export([lessThan/2, grtEqThan/2, qs/1, randomElems/3, compareSpeed/3]).

lessThan(List, Arg) -> [X || X <- List, X < Arg].
grtEqThan(List, Arg) -> [X || X <- List, X>=Arg].

qs([])-> [];
qs([Pivot|Tail]) -> qs(lessThan(Tail,Pivot)) ++ [Pivot] ++ qs(grtEqThan(Tail,Pivot)).

randomElems(N, Min, Max) ->
  [rand:uniform(Max-Min) + Min || _ <- lists:seq(1, N)].


compareSpeed(List, Fun1, Fun2) ->
 (timer:tc(Fun1, [List])/(timer:tc(Fun2, [List]))).

