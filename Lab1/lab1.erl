%%%-------------------------------------------------------------------
%%% @author Dell Latitude E7440
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. mar 2019 17:35
%%%-------------------------------------------------------------------
-module(lab1).
-author("Dell Latitude E7440").

%% API

-export([power/2]).

%Zad.2

power(0, _ ) -> 0;
power(1, _) -> 1;
power(_, 0) -> 1;
power(N, P) -> N*power(N, P-1).


