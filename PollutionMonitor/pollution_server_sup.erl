%%%-------------------------------------------------------------------
%%% @author aleksandra
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. kwi 2019 13:18
%%%-------------------------------------------------------------------
-module(pollution_server_sup).
-author("aleksandra").

%% dodac funkcje crashujaca, ktora ma zepsuc serwer
%% potem postawic serwer na nogi

%% API
-export([start/0, stop/0, loop/0]).

-export([crash/0]).

loop() ->
  process_flag(trap_exit, true),
  pollution_server:start(),
  receive
    {'EXIT', Pid, Msg} -> io:format("Reason: ~w", Msg), loop()
  end.

start() ->
  PID = spawn(pollution_server_sup, loop, []),
  register(sup, PID).

stop() -> sup ! stop.

crash() -> 5/0.