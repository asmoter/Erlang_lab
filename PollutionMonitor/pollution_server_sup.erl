%%%-------------------------------------------------------------------
%%% @author asmoter
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. maj 2019 19:14
%%%-------------------------------------------------------------------
-module(pollution_server_sup).
-author("asmoter").

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