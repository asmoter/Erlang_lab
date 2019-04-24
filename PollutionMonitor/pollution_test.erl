%%%-------------------------------------------------------------------
%%% @author Dell Latitude E7440
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%%
%%%-------------------------------------------------------------------
-module(pollution_test).
-author("Dell Latitude E7440").
-include_lib("eunit/include/eunit.hrl").

%% API

monitor_test() ->
  pollution:addValue("S2", {{2019, 4, 15}, {12, 8, 13}}, "PM2.5", 40,
    pollution:addValue("S2", {{2019, 3, 30}, {16, 0, 0}}, "PM10", 30,
      pollution:addValue("S1", {{2019, 4, 10}, {17, 10, 45}}, "PM10", 40,
        pollution:addValue("S1", {{2019, 3, 30}, {16, 0, 0}}, "PM10", 20,
        pollution:addStation("S2", {20, 30},
          pollution:addStation("S1", {10, 20},
            pollution:createMonitor())))))).


getStationMean_test() ->
  ?assert(pollution:getStationMean("S1", "PM10", monitor_test()) =:= 30.0).
 %% ?assert(pollution:getStationMean({10, 20}, "PM10", monitor_test()) =:= 30.0).

getDailyMean_test() ->
  ?assert(pollution:getDailyMean({{2019, 3, 30}, {16, 0, 0}}, "PM10", monitor_test()) =:= 25.0).

removeValue_test() ->
  ?assert(pollution:removeValue("S1", {{2019, 4, 10}, {17, 10, 45}}, "PM10", monitor_test()) =:=
    pollution:addValue("S2", {{2019, 4, 15}, {12, 8, 13}}, "PM2.5", 40,
      pollution:addValue("S2", {{2019, 3, 30}, {16, 0, 0}}, "PM10", 30,
          pollution:addValue("S1", {{2019, 3, 30}, {16, 0, 0}}, "PM10", 20,
            pollution:addStation("S2", {20, 30},
              pollution:addStation("S1", {10, 20},
                pollution:createMonitor())))))).


getOneValue_test() ->
  ?assert(pollution:getOneValue("S2",{{2019, 3, 30}, {16, 0, 0}}, "PM10", monitor_test()) =:= 30),
  ?assert(pollution:getOneValue("S1", {{2019, 3, 30}, {16, 0, 0}}, "PM10", monitor_test()) =:= 20).


addStation_test() ->
  ?assert(pollution:addStation("S3", {30, 40}, monitor_test()) =:=
    pollution:addValue("S2", {{2019, 4, 15}, {12, 8, 13}}, "PM2.5", 40,
      pollution:addValue("S2", {{2019, 3, 30}, {16, 0, 0}}, "PM10", 30,
        pollution:addValue("S1", {{2019, 4, 10}, {17, 10, 45}}, "PM10", 40,
          pollution:addValue("S1", {{2019, 3, 30}, {16, 0, 0}}, "PM10", 20,
            pollution:addStation("S3", {30, 40},
              pollution:addStation("S2", {20, 30},
                pollution:addStation("S1", {10, 20},
                  pollution:createMonitor())))))))).

addValue_test() ->
  ?assert(pollution:addValue("S1", {{2019, 4, 15}, {12, 8, 13}}, "PM2.5", 50, monitor_test()) =:=
    pollution:addValue("S2", {{2019, 4, 15}, {12, 8, 13}}, "PM2.5", 40,
      pollution:addValue("S2", {{2019, 3, 30}, {16, 0, 0}}, "PM10", 30,
        pollution:addValue("S1", {{2019, 4, 10}, {17, 10, 45}}, "PM10", 40,
          pollution:addValue("S1", {{2019, 3, 30}, {16, 0, 0}}, "PM10", 20,
            pollution:addValue("S1", {{2019, 4, 15}, {12, 8, 13}}, "PM2.5", 50,
              pollution:addStation("S2", {20, 30},
                pollution:addStation("S1", {10, 20},
                  pollution:createMonitor())))))))).