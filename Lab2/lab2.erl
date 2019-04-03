%%%-------------------------------------------------------------------
%%% @author Dell Latitude E7440
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. mar 2019 13:51
%%%-------------------------------------------------------------------
-module(lab2).
-author("Dell Latitude E7440").

%% API

-export([lessThan/2, grtEqThan/2]).

lessThan(List, Arg) -> [X || X <- List, X < Arg].
grtEqThan(List, Arg) -> [X || X <- List, X>=Arg].