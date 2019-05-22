%%%-------------------------------------------------------------------
%%% @author asmoter
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. maj 2019 19:12
%%%-------------------------------------------------------------------
-module(pollution_server).
-author("asmoter").
%% API

-export([start/0, stop/0, init/0]).
-export([addStation/2, addValue/4, removeValue/3, getOneValue/3, getStationMean/2,
  getDailyMean/2]).
-export([crash/0]).
-import(pollution, [createMonitor/0, addStation/3, addValue/5, removeValue/4, getOneValue/4,
getStationMean/3, getDailyMean/3]).

loop(P) ->
  receive
    {Pid, {addStation, Name, Coordinates}} ->  %%poprawic analogicznie pozostale
      case addStation(Name, Coordinates, P) of
        {error, Msg} -> Pid ! {error, Msg}, loop(P);
        New_P -> Pid ! ok, loop(New_P)
      end;

    {Pid, {addValue, StationID, Date, Type, Value}} ->
      case addValue(StationID, Date, Type, Value, P) of
        {error, Msg} -> Pid ! {error, Msg}, loop(P);
        New_P -> Pid ! ok, loop(New_P)
      end;

    {Pid, {removeValue, StationID, Date, Type}}->
      case removeValue(StationID, Date, Type, P) of
        {error, Msg} -> Pid ! {error, Msg},
          loop(P);
        New_P -> Pid ! ok, loop(New_P)
      end;

    {Pid, {getOneValue, StationID, Date, Type}} ->
      case getOneValue(StationID, Date, Type, P) of
        {error, Msg} -> Pid ! {error, Msg}, loop(P);
        Val -> io:format("Value: ~w~n", [Val]),
          Pid ! ok, loop(P)
      end;

    {Pid, {getStationMean, StationID, Type}} ->
      case getStationMean(StationID, Type, P) of
        {error, Msg} -> Pid ! {error, Msg}, loop(P);
        Mean -> io:format("Station mean: ~.2f~n", [Mean]),
          Pid ! ok, loop(P)
      end;

    {Pid, {getDailyMean, Date, Type}} ->
      case getDailyMean(Date, Type, P) of
        {error, Msg} -> Pid ! {error, Msg}, loop(P);
        Mean -> io:format("Date mean: ~.2f~n", [Mean]),
          Pid ! ok, loop(P)
      end;

    {Pid, {crash}} -> 1/0;
    stop -> stop()
  end.

init()->
  P = createMonitor(),
  loop(P).

start() ->
  PID = spawn(pollution_server, init, []),
  register(server, PID).

stop() -> server ! stop.

call(Message) ->
  server ! {self(), Message},
  receive
    Reply -> Reply
  end.

addStation(Name, Coordinates) ->  call({addStation, Name, Coordinates}).

addValue(StationID, Date, Type, Value) ->  call({addValue, StationID, Date, Type, Value}).

removeValue(StationID, Date, Type) ->  call({removeValue, StationID, Date, Type}).

getOneValue(StationID, Date, Type) ->  call({getOneValue, StationID, Date, Type}).

getStationMean(StationID, Type) ->  call({getStationMean, StationID, Type}).

getDailyMean(Date, Type) ->  call({getDailyMean, Date, Type}).

crash() -> server ! {self(), crash}.
