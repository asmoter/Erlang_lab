%%%-------------------------------------------------------------------
%%% @author Dell Latitude E7440
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. kwi 2019 13:18
%%%-------------------------------------------------------------------
-module(pollution_server).
-author("Dell Latitude E7440").

%% API
-export([start/0, stop/0]).
-export([addStation/2, addValue/4, removeValue/3, getOneValue/3, getStationMean/2,
  getDailyMean/2]).
-import(pollution, [createMonitor/0, addStation/3, addValue/5, removeValue/4, getOneValue/4,
  getStationMean/3, getDailyMean/3]).

loop(P) ->
  receive
    {Pid, {addStation, Name, Coordinates}} -> Pid ! ok,
        New_P = addStation(Name, Coordinates, P),
        loop(New_P);
    {Pid, {addValue, StationID, Date, Type, Value}} -> Pid ! ok,
        New_P = addValue(StationID, Date, Type, Value, P),
        loop(New_P);
    {Pid, {removeValue, StationID, Date, Type}}-> Pid ! ok,
        New_P = removeValue(StationID, Date, Type, P),
        loop(New_P);
    {Pid, {getOneValue, StationID, Date, Type}} -> Pid ! ok,
        New_P = getOneValue(StationID, Date, Type, P),
        loop(New_P);
    {Pid, {getStationName, StationID, Type}} -> Pid ! ok,
      New_P = getStationMean(StationID, Type, P),
      loop(New_P);
    {Pid, {getDailyMean, Date, Type}} -> Pid ! ok,
      New_P = getDailyMean(Date, Type, P),
      loop(New_P);
    stop -> stop()
  end.

init()->
  P = createMonitor(),
  loop(P).

start() -> spawn(server, init()).

stop() -> server ! stop.

addStation(Name, Coordinates) ->
  gen_server:call(pollution_server, {addStation(Name, Coordinates)}).

addValue(StationID, Date, Type, Value) ->
  gen_server:call(pollution_server, {addValue(StationID, Date, Type, Value)}).

removeValue(StationID, Date, Type) ->
  gen_server:call(pollution_server, {removeValue(StationID, Date, Type)}).

getOneValue(StationID, Date, Type) ->
  gen_server:call(pollution_server, {getOneValue(StationID, Date, Type)}).

getStationMean(StationID, Type) ->
  gen_server:call(pollution_server, {getStationMean(StationID, Type)}).

getDailyMean(Date, Type) ->
  gen_server:call(pollution_server, {getDailyMean(Date, Type)}).

