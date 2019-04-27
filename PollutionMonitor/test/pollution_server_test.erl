%%%-------------------------------------------------------------------
%%% @author Dell Latitude E7440
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. kwi 2019 01:30
%%%-------------------------------------------------------------------
-module(pollution_server_test).
-author("Dell Latitude E7440").
-include_lib("eunit/include/eunit.hrl").

%% API
-export([]).

monitor_test() ->
  pollution:addValue("S2", {{2019, 4, 15}, {12, 8, 13}}, "PM2.5", 40,
    pollution:addValue("S2", {{2019, 3, 30}, {16, 0, 0}}, "PM10", 30,
      pollution:addValue("S1", {{2019, 4, 10}, {17, 10, 45}}, "PM10", 40,
        pollution:addValue("S1", {{2019, 3, 30}, {16, 0, 0}}, "PM10", 20,
          pollution:addStation("S2", {20, 30},
            pollution:addStation("S1", {10, 20},
              pollution:createMonitor())))))).


getStationMean_test() ->
  monitor_test(),
  ?assert(pollution_server:getStationMean("S1", "PM10") =:= 30.0),
  pollution_server:stop().

getDailyMean_test() ->
  monitor_test(),
  ?assert(pollution_server:getDailyMean({{2019, 3, 30}, {16, 0, 0}}, "PM10") =:= 25.0),
  pollution_server:stop().

removeValue_test() ->
  monitor_test(),
  ?assert(pollution_server:removeValue("S1", {{2019, 4, 10}, {17, 10, 45}}, "PM10") =:=
    pollution:addValue("S2", {{2019, 4, 15}, {12, 8, 13}}, "PM2.5", 40,
      pollution:addValue("S2", {{2019, 3, 30}, {16, 0, 0}}, "PM10", 30,
        pollution:addValue("S1", {{2019, 3, 30}, {16, 0, 0}}, "PM10", 20,
          pollution:addStation("S2", {20, 30},
            pollution:addStation("S1", {10, 20},
              pollution:createMonitor())))))),
  pollution_server:stop().
