%%%-------------------------------------------------------------------
%%% @author Dell Latitude E7440
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. mar 2019 20:35
%%%-------------------------------------------------------------------
-module(onp).
-author("Dell Latitude E7440").

%% API
-export([onp/1, onp/2, onp2/1, onp2/2, read/1]).

% 1 + 2 * 3 - 4 / 5 + 6       -> 1 2 3 * + 4 5 / - 6 +   => 12.2
% 1 + 2 + 3 + 4 + 5 + 6 * 7   -> 1 2 3 4 5 6 7 * + + + + +  => 57
% ( (4 + 7) / 3 ) * (2 - 19)  -> 4 7 + 3 / 2 19 - *  => -62.(3)
% 17 * (31 + 4) / ( (26 - 15) * 2 - 22 ) - 1  -> 17 31 4 + * 26 15 - 2 * 22 - / 1 -  =>  blad, dzielenie przez 0

% Zad.6 Kalkulator ONP

onp(Expr) when is_list(Expr) ->
  [Result] = lists:foldl(fun onp/2, [], string:tokens(Expr, " ")),
  Result.

onp("+", [A,B | Stack]) -> [B+A | Stack];
onp("-", [A,B | Stack]) -> [B-A | Stack];
onp("*", [A,B | Stack]) -> [B*A | Stack];
onp("/", [A,B | Stack]) -> [B/A | Stack];
onp(Key, Stack) -> [list_to_integer(Key)| Stack].

% Zad.dom 2

read(Key) ->
  case string:to_float(Key) of
    {error,no_float} -> list_to_integer(Key);
    {K, _} -> K
  end.

onp2(Expr) when is_list(Expr) ->
  [Result] = lists:foldl(fun onp2/2, [], string:tokens(Expr, " ")),
  Result.

onp2("+", [A,B | Stack]) -> [B+A | Stack];
onp2("-", [A,B | Stack]) -> [B-A | Stack];
onp2("*", [A,B | Stack]) -> [B*A | Stack];
onp2("/", [A,B | Stack]) -> [B/A | Stack];
onp2("sqrt", [A | Stack]) -> [math:sqrt(A) | Stack];
onp2("pow", [A,B | Stack]) -> [math:pow(B,A) | Stack];
onp2("sin", [A | Stack]) -> [math:sin(A) | Stack];
onp2("cos", [A | Stack]) -> [math:cos(A) | Stack];
onp2("tg", [A | Stack]) -> [math:tan(A) | Stack];
onp2("ctg", [A | Stack]) -> [1/math:tan(A) | Stack];
onp2(Key, Stack) -> [read(Key)| Stack].


