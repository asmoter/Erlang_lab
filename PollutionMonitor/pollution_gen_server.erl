%%%-------------------------------------------------------------------
%%% @author asmoter
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. maj 2019 19:08
%%%-------------------------------------------------------------------
-module(pollution_gen_server).
-behavior(gen_server).
-author("asmoter").

%% API
-export([start_link/0, stop/0, init/1, handle_call/3, handle_cast/2]).
-export([addStation/2, addValue/4, removeValue/3, getOneValue/3, getStationMean/2, getDailyMean/2]).


-define(SERVER, ?MODULE).

start_link() ->  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).
stop() ->  gen_server:cast(?MODULE, stop).
init([]) -> {ok, pollution:createMonitor()}.


%% cast
addStation(Name, Coordinates) ->  gen_server:cast(?MODULE, {addStation, Name, Coordinates}).
addValue(StationID, Date, Type, Value) ->  gen_server:cast(?MODULE, {addValue, StationID, Date, Type, Value}).
removeValue(StationID, Date, Type) ->  gen_server:cast(?MODULE, {removeValue, StationID, Date, Type}).

%% call
getOneValue(StationID, Date, Type) ->  gen_server:call(?MODULE, {getOneValue, StationID, Date, Type}).
getStationMean(StationID, Type) -> gen_server:call(?MODULE, {getStationMean, StationID, Type}).
getDailyMean(Date, Type) -> gen_server:call(?MODULE, {getDailyMean, Date, Type}).


%% callbacks
handle_call({getOneValue, StationID, Date, Type}, _From, Monitor) ->
  {reply, pollution:getOneValue(StationID, Date, Type, Monitor), Monitor};
handle_call({getStationMean, StationID, Type}, _From, Monitor) ->
  {reply, pollution:getStationMean(StationID, Type, Monitor), Monitor};
handle_call({getDailyMean, Date, Type}, _From, Monitor) ->
  {reply, pollution:getDailyMean(Date, Type, Monitor), Monitor}.

handle_cast({addStation, Name, Coordinates}, Monitor) ->
  {noreply, pollution:addStation(Name, Coordinates, Monitor)};
handle_cast({addValue, Station, Date, Type, Value}, Monitor) ->
  {noreply, pollution:addValue(Station, Date, Type, Value, Monitor)};
handle_cast({removeValue, StationID, Date, Type}, Monitor) ->
  {noreply, pollution:removeValue(StationID, Date, Type, Monitor)};

handle_cast(stop, Monitor) -> {stop, normal, Monitor}.






