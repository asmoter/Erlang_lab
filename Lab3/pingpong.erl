%%%-------------------------------------------------------------------
%%% @author Dell Latitude E7440
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 04. kwi 2019 09:45
%%%-------------------------------------------------------------------
-module(pingpong).
-author("Dell Latitude E7440").

%% API
-export([start/0, stop/0, play/1, pingLoop/0, pongLoop/0]).


start() ->
  Pid1 = spawn(pingpong, pingLoop, []),
  Pid2 = spawn(?MODULE, pongLoop, []),
  register(ping, Pid1),
  register(pong, Pid2).

stop() ->
  ping ! stop,
  pong ! stop.

play(N) ->
  ping ! N.

pingLoop() ->
  receive
    0 -> pingLoop();
    stop -> ok;
    N -> timer:sleep(1000), pong ! N-1, io:format("Ping odebral: ~w~n", [N]), pingLoop()
  after
    20000 -> ok
  end.

pongLoop() ->
  receive
    0 -> pongLoop;
    stop -> ok;
    N -> timer:sleep(1000), ping ! N-1, io:format("Pong odebral: ~w~n", [N]), pongLoop()
  after
    20000 -> ok
  end.
